import Foundation
import Combine

@MainActor
final class StationSelectionViewModel: ObservableObject {
    init(city: String) {
        self.city = city
    }
    
    let city: String
    
    private var stations: [String] {
        switch city {
        case "Москва":
            return Mocks.moscowMockStations
        case "Санкт-Петербург":
            return Mocks.spbMockStations
        case "Новосибирск":
            return Mocks.novosibirskMockStations
        case "Казань":
            return Mocks.kazanMockStations
        case "Омск":
            return Mocks.omskMockStations
        case "Томск":
            return Mocks.tomskMockStations
        case "Челябинск":
            return Mocks.chelyabinskMockStations
        case "Иркутск":
            return Mocks.irkutskMockStations
        case "Ярославль":
            return Mocks.yaroslavlMockStations
        case "Нижний Новгород":
            return Mocks.nizhnyNovgorodMockStations
        default:
            return []
        }
    }
    
    @Published var searchText = ""
    
    var filteredStations: [String] {
        if searchText.isEmpty {
            stations
        } else {
            stations.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var isNotFoundStation: Bool {
        filteredStations.isEmpty && !searchText.isEmpty
    }
    
}
