import Combine
import Foundation

@MainActor
final class CarriersResultsViewModel: ObservableObject {

    private let client: SearchClient

    @Published var timeSelection: Set<TimeIntervals> = []
    @Published var showTransfers: Bool? = nil

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
        carriers
    }
    var isCarriersListEmpty: Bool {
        filteredCarriers.isEmpty
    }

    func search(
        fromCode: String,
        toCode: String,
        date: String? = nil,
        offset: Int? = nil,
        limit: Int? = nil
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
                limit: limit
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

                // Для UI: в приоритете берём start_date (дата рейса), иначе пытаемся получить дату из departure.
                let dateText: String = {
                    if let startDate = segment.start_date, !startDate.isEmpty {
                        return DateTimeHelpers.prettyDateText(fromYyyyMMdd: startDate)
                    }
                    if let dep = departureDate {
                        return DateTimeHelpers.prettyDateText(from: dep)
                    }
                    // если Date не распарсился — попробуем взять YYYY-MM-DD из строки
                    let raw = DateTimeHelpers.dateTextFallback(from: segment.departure)
                    return DateTimeHelpers.prettyDateText(fromYyyyMMdd: raw)
                }()

                let startTimeText = departureDate.map { DateTimeHelpers.timeText(from: $0) }
                    ?? DateTimeHelpers.timeTextFallback(from: segment.departure)

                let endTimeText = arrivalDate.map { DateTimeHelpers.timeText(from: $0) }
                    ?? DateTimeHelpers.timeTextFallback(from: segment.arrival)

                departureDatesLocal.append(departureDate)
                arrivalDatesLocal.append(arrivalDate)

                let duration = segment.duration ?? 0
                let hours = duration / 3600
                let minutes = (duration % 3600) / 60
                let routeTimeText = hours > 0
                    ? "\(hours)ч \(minutes)м"
                    : "\(minutes)м"
                
                let name = segment.thread?.carrier?.title ?? segment.thread?.title ?? "–"
                
                let logo = segment.thread?.carrier?.logo ?? segment.thread?.carrier?.logo_svg ?? ""
                
                let card = CarrierCardModel(
                    date: dateText,
                    startTime: startTimeText,
                    endTime: endTimeText,
                    routeTime: routeTimeText,
                    logo: logo,
                    name: name
                )
                cards.append(card)
            }
            self.departureDates = departureDatesLocal
            self.arrivalDates = arrivalDatesLocal
            self.carriers = cards
        } catch {
            self.errorText = error.localizedDescription
            self.carriers = []
        }
    }
}
