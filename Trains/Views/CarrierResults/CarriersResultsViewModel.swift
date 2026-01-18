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
        date: String? = nil,
        offset: Int? = nil,
        limit: Int? = nil,
        transfers: Bool? = true
    ) async {
        isLoading = true
        errorText = nil
        defer { isLoading = false }
        do {
            let request = try await client.search(
                fromCode: fromCode,
                toCode: toCode,
                date: date,
                offset: offset,
                limit: limit,
                transfers: transfers
            )

            let segments = request.segments ?? []
            print("✅ search: segments=\(segments.count)")
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

                let duration = Int(segment.duration ?? 0)
                let hours = duration / 3600
                let minutes = (duration % 3600) / 60
                let routeTimeText = hours > 0
                    ? "\(hours)ч \(minutes)м"
                    : "\(minutes)м"

                // Имя и логотип перевозчика
                let (name, logo) = extractCarrierPresentation(from: segment)

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
                    logo: logo,
                    name: name,
                    warningText: warningText,
                    transferCity: transferCity
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

    private func extractCarrierPresentation(from segment: Components.Schemas.Segment) -> (name: String, logo: String) {
        // Прямой маршрут
        if segment.has_transfers != true {
            let carrier = segment.thread?.carrier
            let name = carrier?.title ?? "Неизвестный перевозчик"
            let logo = carrier?.logo ?? carrier?.logo_svg ?? ""
            return (name, logo)
        }

        // Маршрут с пересадками: берём перевозчика первого JourneySegment, если получится
        if let details = segment.details {
            for detail in details {
                if case .JourneySegment(let journey) = detail {
                    let carrier = journey.thread?.carrier
                    let name = carrier?.title ?? "Несколько перевозчиков"
                    let logo = carrier?.logo ?? carrier?.logo_svg ?? ""
                    return (name, logo)
                }
            }
        }

        return ("Несколько перевозчиков", "")
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
