import OpenAPIRuntime
import Foundation
import OpenAPIURLSession

typealias AllStationsResponse = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol {
    func getAllStations(
        lang: String?, format: String
        ) async throws -> AllStationsResponse
}

final class StationsListService: StationsListServiceProtocol {
    private let client: Client
    private let apikey: String

    init(apikey: String, client: Client) {
        self.apikey = apikey
        self.client = client
    }
    
    func getAllStations(lang: String?, format: String) async throws -> AllStationsResponse {  let response = try await client.getAllStations(query: .init(apikey: apikey, lang: lang, format: format))
        
        let responseBody = try response.ok.body.html

        let limit = 50 * 1024 * 1024 // 50Mb
        let fullData = try await Data(collecting: responseBody, upTo: limit)

        let allStations = try JSONDecoder().decode(AllStationsResponse.self, from: fullData)

        return allStations
    }
}
