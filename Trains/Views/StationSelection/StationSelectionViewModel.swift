import Foundation
import Combine

@MainActor
final class StationSelectionViewModel: ObservableObject {
    private let stationsRepository: StationsRepository
    private var cancellables = Set<AnyCancellable>()
    private let filterQueue = DispatchQueue(label: "station.filter.queue", qos: .userInitiated)
    
    let city: City

    @Published var searchText: String = ""
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var stations: [Station] = []
    @Published private(set) var filteredStations: [Station] = []
    @Published private(set) var errorText: String? = nil
    
    init(city: City, stationsRepository: StationsRepository) {
        self.city = city
        self.stationsRepository = stationsRepository

        // Debounce на main (UI), фильтрация — в фоне, чтобы не фризить список
        $searchText
            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
            .removeDuplicates()
            // Снимаем "снимок" станций на main, чтобы дальше безопасно фильтровать в фоне
            .map { [weak self] text -> (String, [Station]) in
                guard let self else { return (text, []) }
                return (text, self.stations)
            }
            .receive(on: filterQueue)
            .map { (text, stations) -> [Station] in
                guard !text.isEmpty else { return stations }
                return stations.filter { $0.title.localizedCaseInsensitiveContains(text) }
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                self?.filteredStations = result
            }
            .store(in: &cancellables)
    }

    func load() async {
        isLoading = true
        errorText = nil
        defer {
            isLoading = false
        }
        do {
            stations = try await stationsRepository.getStations(forCityWithId: city.id)
            // Быстро показываем полный список сразу после загрузки
            filteredStations = stations
            // Актуализируем фильтр для уже введённого текста (если он есть)
            applyFilter(with: searchText)
        } catch {
            errorText = "Ошибка загрузки станций"
        }
    }
    
    var isNotFoundStation: Bool {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return filteredStations.isEmpty && !query.isEmpty && !isLoading && errorText == nil
    }

    private func applyFilter(with text: String) {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            filteredStations = stations
            return
        }
        filteredStations = stations.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
}
