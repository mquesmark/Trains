import Foundation
import Combine

@MainActor
final class CitySelectionViewModel: ObservableObject {
    private let stationsRepository: StationsRepository
    @Published var searchText: String = ""
    @Published private(set) var cities: [City] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorText: String? = nil
    
    init(stationsRepository: StationsRepository) {
        self.stationsRepository = stationsRepository
    }
    
    func load() async {
        isLoading = true
        errorText = nil
        defer { isLoading = false }
        
        do {
            try await stationsRepository.loadInfoIfNeeded()
            cities = await stationsRepository.getCities()
        } catch {
            errorText = "Не удалось загрузить список городов"
        }
    }
    
    var filteredCities: [City] {
        guard !searchText.isEmpty else { return cities }
        return cities.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    var isNotFoundState: Bool {
        filteredCities.isEmpty && !searchText.isEmpty
    }
    
}
