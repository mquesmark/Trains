import Foundation

actor StationsRepository {
    private let service: StationsListServiceProtocol

    private var isLoaded: Bool = false
    private var loadTask: Task<([City], [String: [Station]]), Error>?
    private var citiesCache: [City] = []
    private var stationsByCityIdDict: [String: [Station]] = [:]
    init(service: StationsListServiceProtocol) {
        self.service = service
    }

    func loadInfoIfNeeded() async throws {
        if isLoaded { return }

        if let task = loadTask {
            let (cities, dict) = try await task.value
            self.citiesCache = cities
            self.stationsByCityIdDict = dict
            self.isLoaded = true
            return
        }

        // Стартуем новую загрузку
        let task = Task<([City], [String: [Station]]), Error> { [service] in
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

                        cities.append(City(id: cityId, title: cityTitle))

                        let stations = (settlement.stations ?? []).compactMap { station -> Station? in
                            guard let title = station.title,
                                  let code = station.codes?.yandex_code,
                                  !code.isEmpty
                            else { return nil }

                            let stationTypeRaw = station.station_type
                            let stationType = StationType(rawValue: stationTypeRaw ?? "") ?? .unknown
                            return Station(id: code, title: title, stationType: stationType)
                        }

                        if !stations.isEmpty {
                            cityToStationsDictionary[cityId] = stations
                        }
                    }
                }
            }

            cities.sort { $0.title < $1.title }
            return (cities, cityToStationsDictionary)
        }

        loadTask = task
        defer { loadTask = nil }

        let (cities, dict) = try await task.value
        self.citiesCache = cities
        self.stationsByCityIdDict = dict
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
