import Foundation
import Combine

@MainActor
final class CitySelectionViewModel: ObservableObject {
    private let cities: [String] = Mocks.citiesStrings
    @Published var searchText = ""
    
    var filteredCities: [String] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter{
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var isNotFoundState: Bool {
        filteredCities.isEmpty && !searchText.isEmpty
    }
    
}
