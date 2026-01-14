import Foundation
import Combine

@MainActor
final class MainScreenViewModel: ObservableObject {
    
    @Published var fromCity: String? = nil
    @Published var fromStation: String? = nil
    @Published var toCity: String? = nil
    @Published var toStation: String? = nil
    
    @Published var storiesPreview: [Story] = Mocks.stories
    
    var canSearch: Bool {
        fromCity != nil && fromStation != nil && toCity != nil && toStation != nil
    }
    
    var routeString: String? {
        guard let fromCity, let fromStation, let toCity, let toStation else { return nil }
        return "\(fromCity) (\(fromStation)) → \(toCity) (\(toStation))"

    }
    
    func swapDirections() {
        swap(&fromCity, &toCity)
        swap(&fromStation, &toStation)
    }

    func markStoryWatched(id: Story.ID) {
        if let index = storiesPreview.firstIndex(where: { $0.id == id }) {
            storiesPreview[index].isWatched = true
        }
    }
}
