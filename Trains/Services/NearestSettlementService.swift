import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestCityResponse = Components.Schemas.NearestCityResponse

protocol NearestSettlementServiceProtocol {
    func getNearestCity(lat: Double, lng: Double, distance: Int?, lang: String?, format: String?)
    async throws -> NearestCityResponse
}

final class NearestSettlementService: NearestSettlementServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getNearestCity(lat: Double, lng: Double, distance: Int? = nil, lang: String? = nil, format: String? = nil) async throws -> NearestCityResponse {
        let response = try await client.getNearestCity(
            query: .init(
                apikey: apikey,
                lat: lat,
                lng: lng,
                distance: distance,
                lang: lang,
                format: format
            ))
        return try response.ok.body.json
    }
}
