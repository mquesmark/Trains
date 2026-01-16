import Foundation
import Combine

@MainActor
final class StationSelectionViewModel: ObservableObject {
    private let stationsRepository: StationsRepository
    
    init(city: City, stationsRepository: StationsRepository) {
        self.city = city
        self.stationsRepository = stationsRepository
    }
    
    let city: City
        
    @Published var searchText = ""
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var stations: [Station] = []
    @Published private(set) var errorText: String? = nil
    
    var filteredStations: [Station] {
        if searchText.isEmpty {
            stations
        } else {
            stations.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func load() async {
        isLoading = true
        errorText = nil
        defer {
            isLoading = false
        }
        do {
            try await stationsRepository.loadInfoIfNeeded()
            stations = await stationsRepository.getStations(forCityWithId: city.id)
        } catch {
            errorText = "Ошибка загрузки станций"
        }
        
    }
    
    var isNotFoundStation: Bool {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return filteredStations.isEmpty && !query.isEmpty && !isLoading && errorText == nil
    }
    
}
