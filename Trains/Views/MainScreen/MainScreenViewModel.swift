import Foundation
import Combine

@MainActor
final class MainScreenViewModel: ObservableObject {

    @Published var fromCity: City?
    @Published var fromStation: Station?
    @Published var toCity: City?
    @Published var toStation: Station?
    
    @Published var storiesPreview: [Story] = Mocks.stories
    
    private let stationsRepository: StationsRepository
    init(stationsRepository: StationsRepository) {
        self.stationsRepository = stationsRepository
    }
    
    var canSearch: Bool {
        fromCity != nil && fromStation != nil && toCity != nil && toStation != nil
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
