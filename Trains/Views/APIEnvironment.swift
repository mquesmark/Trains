import Foundation
import OpenAPIURLSession

final class APIEnvironment {
    static let shared = APIEnvironment()
    private init() {}

    private static let serverURL: URL = {
        do {
            return try Servers.Server1.url()
        } catch {
            assertionFailure("Failed to build server URL from OpenAPI Servers: \(error)")
            guard let fallback = URL(string: "https://api.rasp.yandex-net.ru") else {
                fatalError("Invalid fallback server URL")
            }
            return fallback
        }
    }()

    lazy private(set) var stationsRepository: StationsRepository = {
        let client = Client(
            serverURL: Self.serverURL,
            transport: URLSessionTransport()
        )
        let service = StationsListService(
            apikey: UserInfo.apikey,
            client: client
        )

        return StationsRepository(service: service)
    }()

    private(set) lazy var searchClient: SearchClient = {
        let client = Client(
            serverURL: Self.serverURL,
            transport: URLSessionTransport()
        )
        let service = SearchService(client: client, apikey: UserInfo.apikey)
        return SearchClient(service: service)
    }()
}
