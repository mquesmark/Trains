import Foundation
import OpenAPIURLSession

enum APITests {
    static func testCarrierService() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = CarrierService(
                    client: client,
                    apikey: UserInfo.apikey
                )
                
                print("Fetching carrier info...")
                
                let carrier = try await service.getCarrierInfo(
                    code: "680"
                )
                
                print("Successfully fetched carrier info: \(carrier)")
            } catch {
                print("Error fetching carrier info: \(error)")
            }
        }
    }
    static func testCopyrightService() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = CopyrightService(
                    client: client,
                    apikey: UserInfo.apikey
                )
                
                print("Fetching copyright...")
                
                let copyright = try await service.getCopyright()
                
                print("Successfully fetched copyright: \(copyright)")
            } catch {
                print("Error fetching copyright: \(error)")
            }
        }
    }
    static func testNearestSettlementService() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = NearestSettlementService(
                    client: client,
                    apikey: UserInfo.apikey
                )

                print("Fetching nearest city...")
                
                let city = try await service.getNearestCity(
                    lat: 50.440046,
                    lng: 40.4882367,
                    distance: 50,
                    lang: "ru_RU",
                    format: "json"
                )
                
                print("Successfully fetched nearest city: \(city)")
            } catch {
                print("Error fetching nearest city: \(error)")
            }
        }
    }
    static func testNearestStationsService() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = NearestStationsService(
                    client: client,
                    apikey: UserInfo.apikey
                )

                print("Fetching nearest stations...")

                let stations = try await service.getNearestStations(
                    lat: 50.440046,
                    lng: 40.4882367,
                    distance: 50
                )

                print("Successfully fetched nearest stations: \(stations)")
            } catch {
                print("Error fetching nearest stations: \(error)")
            }
        }
    }
    static func testScheduleService() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )

                let service = ScheduleService(
                    client: client,
                    apikey: UserInfo.apikey
                )

                print("Fetching station schedule...")

                let schedule = try await service.getStationSchedule(
                    station: "s9600213",
                    transportTypes: "suburban",
                    direction: "на Москву"
                )

                print("Successfully fetched schedule: \(schedule)")
            } catch {
                print("Error fetching schedule: \(error)")
            }
        }
    }
    static func testSearchService() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )

                let service = SearchService(
                    client: client,
                    apikey: UserInfo.apikey
                )

                print("Fetching search segments...")

                let segments = try await service.getScheduleBetweenStations(
                    from: "c146",
                    to: "c213",
                    date: "2025-11-30",
                    offset: 1
                )

                print("Successfully fetched segments: \(segments)")
            } catch {
                print("Error fetching search segments: \(error)")
            }
        }
    }
    static func testStationsListService() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = StationsListService(
                    apikey: UserInfo.apikey,
                    client: client
                )

                print("Fetching all stations...")

                let stationsList = try await service.getAllStations(
                    lang: nil,
                    format: "json"
                )

                print("Successfully fetched stations list: \(stationsList)")
            } catch {
                print("Error fetching stations list: \(error)")
            }
        }
    }
    static func testThreadService() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )

                let service = ThreadService(
                    client: client,
                    apikey: UserInfo.apikey
                )

                print("Fetching thread route stations...")

                let thread = try await service.getRouteStations(
                    uid: "068S_1_2",
                    format: "json",
                    lang: "ru_RU",
                    date: "2025-11-30",
                    show_systems: "all"
                )

                print("Successfully fetched thread route stations: \(thread)")
            } catch {
                print("Error fetching thread route stations: \(error)")
            }
        }
    }
}
