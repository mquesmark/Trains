import Foundation
import OpenAPIURLSession

final class APIEnvironment {
    static let shared = APIEnvironment()
    private init() {}
    
    lazy private(set) var stationsRepository: StationsRepository = {
        let client = Client(
            serverURL: try! Servers.Server1.url(),
            transport: URLSessionTransport()
        )
        let service = StationsListService(apikey: UserInfo.apikey, client: client)
        
        return StationsRepository(service: service)
    }()
}
