import Foundation

actor StationsRepository {
    private let service: StationsListServiceProtocol

    private var isLoaded: Bool = false
    private var citiesCache: [City] = []
    private var stationsByCityIdDict: [String: [Station]] = [:]
    private var isLoading: Bool = false
    init(service: StationsListServiceProtocol) {
        self.service = service
    }

    private func loadInfoIfNeeded() async throws {
        guard !isLoaded && !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        let response = try await service.getAllStations(
            lang: "ru_RU",
            format: "json"
        )

        var cities: [City] = []
        var cityToStationsDictionary: [String: [Station]] = [:]

        let countries = response.countries ?? []
        for country in countries {
            let regions = country.regions ?? []
            for region in regions {
                let settlements = region.settlements ?? []
                for settlement in settlements {
                    guard let cityTitle = settlement.title,
                          let cityId = settlement.codes?.yandex_code,
                          !cityId.isEmpty
                    else { continue }
                    
                    let city = City(id: cityId, title: cityTitle)
                    cities.append(city)
                    
                    let stations = (settlement.stations ?? []).compactMap { station -> Station? in
                        guard let title = station.title,
                              let code = station.codes?.yandex_code,
                              !code.isEmpty
                        else { return nil }
                        return Station(id: code, title: title)
                    }
                    if !stations.isEmpty {
                        cityToStationsDictionary[cityId] = stations
                    }
                }
            }
        }
        cities.sort {  $0.title < $1.title }
        
        self.citiesCache = cities
        self.stationsByCityIdDict = cityToStationsDictionary
        self.isLoaded = true
    }

    func getCities() async throws -> [City] {
        try await loadInfoIfNeeded()
        return citiesCache
    }

    func getStations(forCityWithId cityId: String) async throws -> [Station] {
        try await loadInfoIfNeeded()
        return stationsByCityIdDict[cityId] ?? []
    }
}
