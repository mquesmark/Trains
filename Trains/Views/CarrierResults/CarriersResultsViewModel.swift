import Combine
import Foundation

@MainActor
final class CarriersResultsViewModel: ObservableObject {

    private let client: SearchClient

    @Published var timeSelection: Set<TimeIntervals> = []
    @Published var showTransfers: Bool? = nil

    @Published private(set) var carriers: [CarrierCardModel] = []
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
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
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
            
            for segment in segments {
                
                let departureDate: Date? = segment.departure
                let arrivalDate: Date? = segment.arrival
                let dateText = departureDate.map { dateFormatter.string(from: $0) } ?? ""
                let startTimeText = departureDate.map { timeFormatter.string(from: $0) } ?? ""
                let endTimeText = arrivalDate.map { timeFormatter.string(from: $0) } ?? ""

                let duration = segment.duration ?? 0
                let hours = duration / 3600
                let minutes = (duration % 3600) / 60
                let routeTimeText = hours > 0
                    ? "\(hours)ч \(minutes)м"
                    : "\(minutes)м"
                
                let name = segment.thread?.carrier?.title ?? segment.thread?.title ?? "–"
                
                let logo = segment.thread?.carrier?.logo ?? ""
                
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
            self.carriers = cards
        } catch {
            self.errorText = error.localizedDescription
            self.carriers = []
        }
    }
}
