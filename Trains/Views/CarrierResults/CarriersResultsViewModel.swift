import Combine
import Foundation

@MainActor
final class CarriersResultsViewModel: ObservableObject {

    private let client: SearchClient

    @Published var timeSelection: Set<TimeIntervals> = []
    @Published var showTransfers: Bool? = true

    @Published private(set) var carriers: [CarrierCardModel] = []
    // Сохраняем Date для фильтров по времени (индексы совпадают с `carriers`)
    private(set) var departureDates: [Date?] = []
    private(set) var arrivalDates: [Date?] = []

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorText: String? = nil

    init(client: SearchClient) {
        self.client = client
    }

    var filteredCarriers: [CarrierCardModel] {
        var result = carriers

        // Фильтр пересадок
        // showTransfers == true  -> показываем ВСЕ варианты (включая пересадки)
        // showTransfers == false -> показываем только БЕЗ пересадок
        // nil -> без фильтра
        if let showTransfers = showTransfers {
            if showTransfers == false {
                result = result.filter { $0.warningText == nil }
            }
        }

        // Фильтр по времени (если выбран)
        if !timeSelection.isEmpty {
            result = result.enumerated().filter { index, _ in
                guard index < departureDates.count else { return true }
                guard let date = departureDates[index] else { return true }
                let hour = Calendar.current.component(.hour, from: date)

                for interval in timeSelection {
                    if interval.range.contains(hour) { return true }
                }
                return false
            }.map { $0.element }
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
            let effectiveDate: String? = shouldIncludeTransfers ? DateTimeHelpers.todayYyyyMmDd() : nil

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

            var departureDatesLocal: [Date?] = []
            var arrivalDatesLocal: [Date?] = []
            departureDatesLocal.reserveCapacity(segments.count)
            arrivalDatesLocal.reserveCapacity(segments.count)

            for segment in segments {

                let departureDate = DateTimeHelpers.parse(segment.departure)
                let arrivalDate = DateTimeHelpers.parse(segment.arrival)

                let dateText: String = {
                    if let startDate = segment.start_date, !startDate.isEmpty {
                        return DateTimeHelpers.prettyDateText(fromYyyyMMdd: startDate)
                    }
                    if let dep = departureDate {
                        return DateTimeHelpers.prettyDateText(from: dep)
                    }
                    let raw = DateTimeHelpers.dateTextFallback(from: segment.departure)
                    return DateTimeHelpers.prettyDateText(fromYyyyMMdd: raw)
                }()

                let startTimeText = departureDate.map { DateTimeHelpers.timeText(from: $0) }
                    ?? DateTimeHelpers.timeTextFallback(from: segment.departure)

                let endTimeText = arrivalDate.map { DateTimeHelpers.timeText(from: $0) }
                    ?? DateTimeHelpers.timeTextFallback(from: segment.arrival)

                departureDatesLocal.append(departureDate)
                arrivalDatesLocal.append(arrivalDate)

                let durationSeconds: Int = {
                    // 1) Если API отдал duration — используем
                    if let apiDuration = segment.duration {
                        return max(0, Int(apiDuration))
                    }

                    // 2) Fallback: считаем по разнице дат (работает и для пересадок)
                    if let dep = departureDate, let arr = arrivalDate {
                        return max(0, Int(arr.timeIntervalSince(dep)))
                    }

                    // 3) Последний fallback: суммируем duration внутри details
                    if let details = segment.details {
                        var sum: Double = 0
                        for detail in details {
                            switch detail {
                            case .JourneySegment(let journey):
                                sum += journey.duration ?? 0
                            case .TransferStop(let transferStop):
                                sum += transferStop.duration ?? 0
                            }
                        }
                        return max(0, Int(sum))
                    }

                    return 0
                }()

                let hours = durationSeconds / 3600
                let minutes = (durationSeconds % 3600) / 60
                let routeTimeText = hours > 0
                    ? "\(hours)ч \(minutes)м"
                    : "\(minutes)м"

                let carriersInfo = extractCarrierPresentation(from: segment)

                // Пересадка: город берём из `transfers`, а если нет — из `details` (TransferStop)
                let transferCity = extractTransferCity(from: segment)
                let warningText: String? = {
                    guard segment.has_transfers == true else { return nil }
                    if let city = transferCity, !city.isEmpty {
                        let cleaned = city
                            .replacingOccurrences(of: " вокзал", with: "")
                            .replacingOccurrences(of: " станция", with: "")
                            .replacingOccurrences(of: " ст.", with: "")
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        return cleaned.isEmpty ? "С пересадкой" : "С пересадкой в \(cleaned)"
                    }
                    return "С пересадкой"
                }()

                let card = CarrierCardModel(
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

            self.departureDates = departureDatesLocal
            self.arrivalDates = arrivalDatesLocal
            self.carriers = cards
        } catch {
            // Приводим "сырой" 404 от OpenAPI к понятному сообщению.
            if let httpError = error as? APIHTTPError {
                switch httpError {
                case let .undocumented(statusCode, body):
                    if statusCode == 404,
                       let body,
                       body.contains("Не нашли объект по yandex коду") {
                        self.errorText = "Яндекс.Расписания не нашли выбранную станцию. Выберите другую."
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

    private func extractCarrierPresentation(from segment: Components.Schemas.Segment) -> CarrierInfo {
        // Прямой маршрут
        if segment.has_transfers != true {
            let carrier = segment.thread?.carrier
            let code = carrier?.code
            let name = carrier?.title ?? ""
            let logo = carrier?.logo ?? carrier?.logo_svg ?? ""
            let email = carrier?.email ?? ""
            let phone = carrier?.phone ?? ""
            return CarrierInfo(code: code, logoUrlString: logo, name: name, email: email, phone: phone)
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
                    return CarrierInfo(code: code, logoUrlString: logo, name: name, email: email, phone: phone)
                }
            }
        }

        return CarrierInfo(code: nil, logoUrlString: "", name: "Несколько перевозчиков", email: "", phone: "")
    }

    private func extractTransferCity(from segment: Components.Schemas.Segment) -> String? {
        guard segment.has_transfers == true else { return nil }

        // 1) Приоритет: поле `transfers`
        if let transfers = segment.transfers, let first = transfers.first {
            switch first {
            case .Location(let location):
                return location.popular_title ?? location.title ?? location.short_title
            case .Station(let station):
                return station.popular_title ?? station.title ?? station.short_title
            }
        }

        // 2) Fallback: ищем TransferStop в `details`
        if let details = segment.details {
            for detail in details {
                if case .TransferStop(let transferStop) = detail {
                    if let point = transferStop.transfer_point {
                        return point.popular_title ?? point.title ?? point.short_title
                    }
                }
            }
        }

        return nil
    }
}

private extension DateTimeHelpers {
    static func todayYyyyMmDd() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
