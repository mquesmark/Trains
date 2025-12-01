import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierResponse = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func getCarrierInfo(code: String, system: String?, lang: String?, format: String?) async throws -> CarrierResponse
}

final class CarrierService: CarrierServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getCarrierInfo(code: String, system: String? = nil, lang: String? = nil, format: String? = nil) async throws -> CarrierResponse {
        let response = try await client.getCarrierInfo(
            query: .init(
            apikey: apikey,
            code: code,
            system: system,
            lang: lang,
            format: format
            ))
        return try response.ok.body.json
    }
    
    
}
