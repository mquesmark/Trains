import Foundation

actor SearchClient {
    private let service: SearchServiceProtocol

    init(service: SearchServiceProtocol) {
        self.service = service
    }

    func search(
        fromCode: String,
        toCode: String,
        date: String? = nil,
        offset: Int? = nil,
        limit: Int? = nil,
        transfers: Bool? = true
    ) async throws -> SearchSegments {
        try await service.getScheduleBetweenStations(
            from: fromCode,
            to: toCode,
            format: nil,
            lang: nil,
            date: date,
            transportTypes: nil,
            offset: offset,
            limit: limit,
            resultTimezone: nil,
            transfers: transfers
        )
    }
}
