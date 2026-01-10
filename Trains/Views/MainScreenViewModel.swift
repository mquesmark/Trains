import Observation
import Foundation

@Observable
final class MainScreenViewModel {
    
    var fromCity: String? = nil
    var fromStation: String? = nil
    var toCity: String? = nil
    var toStation: String? = nil
    
    var storiesPreview: [Story] = Mocks.stories
    
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
