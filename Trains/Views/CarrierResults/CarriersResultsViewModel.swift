import Combine
import Foundation

@MainActor
final class CarriersResultsViewModel: ObservableObject {

    private let client: SearchClient

    @Published var timeSelection: Set<TimeIntervals> = []
    @Published var showTransfers: Bool = true

    @Published private(set) var carriers: [CarrierCardModel] = []

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorText: String?

    init(client: SearchClient) {
        self.client = client
    }

    var filteredCarriers: [CarrierCardModel] {
        var result = carriers

        if !showTransfers {
            result = result.filter { $0.warningText == nil }
        }

        // Фильтр по времени (если выбран)
        if !timeSelection.isEmpty {
            result = result.filter { carrier in
                let date = carrier.departureDate
                let hour = Calendar.current.component(.hour, from: date)
                return timeSelection.contains { $0.range.contains(hour) }
            }
        }

        result.sort {  // Сортируем результаты по возрастанию даты
            if $0.departureDate != $1.departureDate {
                return $0.departureDate < $1.departureDate
            }
            return $0.arrivalDate < $1.arrivalDate  // на случай, если время отправления одинаковое
        }
        return result
    }

    var isCarriersListEmpty: Bool {
        filteredCarriers.isEmpty
    }

    func search(
        fromCode: String,
        toCode: String,
        offset: Int? = nil,
        limit: Int? = nil,
        transfers: Bool? = true
    ) async {
        isLoading = true
        errorText = nil
        defer { isLoading = false }
        do {
            let shouldIncludeTransfers = transfers ?? true
            let effectiveDate: String? =
                shouldIncludeTransfers ? DateTimeHelpers.todayYyyyMmDd() : nil

            let request = try await client.search(
                fromCode: fromCode,
                toCode: toCode,
                date: effectiveDate,
                offset: offset,
                limit: limit,
                transfers: transfers
            )

            let segments = request.segments ?? []
            var cards: [CarrierCardModel] = []
            cards.reserveCapacity(segments.count)

            for segment in segments {
                let baseDate =
                    (segment.start_date?.isEmpty == false
                        ? segment.start_date : nil)
                    ?? effectiveDate

                let departureDate = DateTimeHelpers.parse(
                    segment.departure,
                    baseDateYyyyMmDd: baseDate
                )

                let arrivalDateRaw = DateTimeHelpers.parse(
                    segment.arrival,
                    baseDateYyyyMmDd: baseDate
                )
                let arrivalDate: Date? = {
                    guard let dep = departureDate, let arr = arrivalDateRaw
                    else { return arrivalDateRaw }
                    if arr < dep {
                        return Calendar.current.date(
                            byAdding: .day,
                            value: 1,
                            to: arr
                        )
                    }
                    return arr
                }()

                guard let departureDate, let arrivalDate else {
                    print(
                        "PARSE FAIL departure:",
                        segment.departure ?? "nil",
                        "arrival:",
                        segment.arrival ?? "nil"
                    )
                    continue
                }

                let dateText: String = {
                    if let startDate = segment.start_date, !startDate.isEmpty {
                        return DateTimeHelpers.prettyDateText(
                            fromYyyyMMdd: startDate
                        )
                    }
                    return DateTimeHelpers.prettyDateText(from: departureDate)
                }()

                let startTimeText = DateTimeHelpers.timeText(
                    from: departureDate
                )

                let endTimeText = DateTimeHelpers.timeText(from: arrivalDate)

                let durationSeconds: Int = {
                    // 1) Если API отдал duration — используем
                    if let apiDuration = segment.duration {
                        return max(0, Int(apiDuration))
                    }

                    // 2) Fallback: считаем по разнице дат
                    return max(
                        0,
                        Int(arrivalDate.timeIntervalSince(departureDate))
                    )
                }()

                let hours = durationSeconds / 3600
                let minutes = (durationSeconds % 3600) / 60
                let routeTimeText =
                    hours > 0
                    ? "\(hours)ч \(minutes)м"
                    : "\(minutes)м"

                let carriersInfo = extractCarrierPresentation(from: segment)

                // Пересадка: город берём из `transfers`, а если нет — из `details` (TransferStop)
                let transferCity = extractTransferCity(from: segment)
                let warningText: String? = {
                    guard segment.has_transfers == true else { return nil }
                    if let city = transferCity, !city.isEmpty {
                        let cleaned =
                            city
                            .replacingOccurrences(of: " вокзал", with: "")
                            .replacingOccurrences(of: " станция", with: "")
                            .replacingOccurrences(of: " ст.", with: "")
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        return cleaned.isEmpty
                            ? "С пересадкой" : "С пересадкой в \(cleaned)"
                    }
                    return "С пересадкой"
                }()

                let card = CarrierCardModel(
                    departureDate: departureDate,
                    arrivalDate: arrivalDate,
                    date: dateText,
                    startTime: startTimeText,
                    endTime: endTimeText,
                    routeTime: routeTimeText,
                    warningText: warningText,
                    transferCity: transferCity,
                    carrierInfo: carriersInfo
                )

                cards.append(card)
            }
            self.carriers = cards
        } catch {
            // Приводим "сырой" 404 от OpenAPI к понятному сообщению.
            if let httpError = error as? APIHTTPError {
                switch httpError {
                case .undocumented(let statusCode, let body):
                    if statusCode == 404,
                        let body,
                        body.contains("Не нашли объект по yandex коду")
                    {
                        self.errorText =
                            "Яндекс.Расписания не нашли выбранную станцию. Выберите другую."
                    } else {
                        self.errorText = httpError.localizedDescription
                    }
                }
            } else {
                self.errorText = error.localizedDescription
            }

            self.carriers = []
        }
    }

    // MARK: - Transfers helpers

    private func extractCarrierPresentation(
        from segment: Components.Schemas.Segment
    ) -> CarrierInfo {
        // Прямой маршрут
        if segment.has_transfers != true {
            let carrier = segment.thread?.carrier
            let code = carrier?.code
            let name = carrier?.title ?? ""
            let logo = carrier?.logo ?? carrier?.logo_svg ?? ""
            let email = carrier?.email ?? ""
            let phone = carrier?.phone ?? ""
            return CarrierInfo(
                code: code,
                logoUrlString: logo,
                name: name,
                email: email,
                phone: phone
            )
        }

        // Маршрут с пересадками: берём перевозчика первого JourneySegment, если получится
        if let details = segment.details {
            for detail in details {
                if case .JourneySegment(let journey) = detail {
                    let carrier = journey.thread?.carrier
                    let code = carrier?.code
                    let name = carrier?.title ?? "Несколько перевозчиков"
                    let logo = carrier?.logo ?? carrier?.logo_svg ?? ""
                    let email = carrier?.email ?? ""
                    let phone = carrier?.phone ?? ""
                    return CarrierInfo(
                        code: code,
                        logoUrlString: logo,
                        name: name,
                        email: email,
                        phone: phone
                    )
                }
            }
        }

        return CarrierInfo(
            code: nil,
            logoUrlString: "",
            name: "Несколько перевозчиков",
            email: "",
            phone: ""
        )
    }

    private func extractTransferCity(from segment: Components.Schemas.Segment)
        -> String?
    {
        guard segment.has_transfers == true else { return nil }

        // 1) Приоритет: поле `transfers`
        if let transfers = segment.transfers, let first = transfers.first {
            switch first {
            case .Location(let location):
                return location.popular_title ?? location.title
                    ?? location.short_title
            case .Station(let station):
                return station.popular_title ?? station.title
                    ?? station.short_title
            }
        }

        // 2) Fallback: ищем TransferStop в `details`
        if let details = segment.details {
            for detail in details {
                if case .TransferStop(let transferStop) = detail {
                    if let point = transferStop.transfer_point {
                        return point.popular_title ?? point.title
                            ?? point.short_title
                    }
                }
            }
        }

        return nil
    }
}

extension DateTimeHelpers {
    fileprivate static func todayYyyyMmDd() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
