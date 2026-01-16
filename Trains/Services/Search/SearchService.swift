import OpenAPIRuntime
import OpenAPIURLSession

typealias SearchSegments = Components.Schemas.Segments

protocol SearchServiceProtocol {
    func getScheduleBetweenStations(
        from: String,
        to: String,
        format: String?,
        lang: String?,
        date: String?,
        transportTypes: String?,
        offset: Int?,
        limit: Int?,
        resultTimezone: String?,
        transfers: Bool?
    ) async throws -> SearchSegments
}

final class SearchService: SearchServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    /// Получить расписание рейсов между двумя станциями Яндекс.Расписаний.
    /// - Parameters:
    ///   - from: Код станции отправления.
    ///   - to: Код станции прибытия.
    ///   - format: Формат ответа (по умолчанию JSON).
    ///   - lang: Язык ответа (например, ru_RU).
    ///   - date: Дата в формате YYYY-MM-DD.
    ///   - transportTypes: Тип транспорта (plane, train, bus и т.д.).
    ///   - offset: Смещение результатов.
    ///   - limit: Лимит на количество результатов.
    ///   - resultTimezone: Часовой пояс для дат и времени в ответе.
    ///   - transfers: Включить маршруты с пересадками.
    func getScheduleBetweenStations(
        from: String,
        to: String,
        format: String? = nil,
        lang: String? = nil,
        date: String? = nil,
        transportTypes: String? = nil,
        offset: Int? = nil,
        limit: Int? = nil,
        resultTimezone: String? = nil,
        transfers: Bool? = nil
    ) async throws -> SearchSegments {
        let response = try await client.getScheduleBetweenStations(
            query: .init(
                apikey: apikey,
                from: from,
                to: to,
                format: format,
                lang: lang,
                date: date,
                transport_types: transportTypes,
                offset: offset,
                limit: limit,
                result_timezone: resultTimezone,
                transfers: transfers
            )
        )
        return try response.ok.body.json
    }
}
