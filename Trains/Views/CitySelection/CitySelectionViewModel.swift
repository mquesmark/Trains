import Foundation
import Combine

@MainActor
final class CitySelectionViewModel: ObservableObject {
    private let stationsRepository: StationsRepository
    private var cancellables = Set<AnyCancellable>()
    private let filterQueue = DispatchQueue(label: "city.filter.queue", qos: .userInitiated)

    @Published var searchText: String = ""
    @Published private(set) var cities: [City] = []
    @Published private(set) var filteredCities: [City] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorText: String?

    init(stationsRepository: StationsRepository) {
        self.stationsRepository = stationsRepository

        // Делаем debounce на main (UI), а саму фильтрацию — в фоне, чтобы не фризить список
        $searchText
            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
            .removeDuplicates()
            // Снимаем "снимок" городов на main, чтобы дальше безопасно фильтровать в фоне
            .map { [weak self] text -> (String, [City]) in
                guard let self else { return (text, []) }
                return (text, self.cities)
            }
            .receive(on: filterQueue)
            .map { (text, cities) -> [City] in
                guard !text.isEmpty else { return cities }
                return cities.filter { $0.title.localizedCaseInsensitiveContains(text) }
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                self?.filteredCities = result
            }
            .store(in: &cancellables)
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorText = nil
        defer { isLoading = false }

        do {
            cities = try await stationsRepository.getCities()
            // Быстро показываем полный список сразу после загрузки
            filteredCities = cities
            // Актуализируем фильтр для уже введённого текста (если он есть)
            applyFilter(with: searchText)
        } catch {
            errorText = "Не удалось загрузить список городов"
        }
    }

    var isNotFoundState: Bool {
        filteredCities.isEmpty && !searchText.isEmpty
    }

    private func applyFilter(with text: String) {
        guard !text.isEmpty else {
            filteredCities = cities
            return
        }
        filteredCities = cities.filter { $0.title.localizedCaseInsensitiveContains(text) }
    }
}
