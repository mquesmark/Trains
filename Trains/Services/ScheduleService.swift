import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleResponse = Components.Schemas.ScheduleResponse

protocol ScheduleServiceProtocol {
    func getStationSchedule(
        station: String,
        lang: String?,
        format: String?,
        date: String?,
        transportTypes: String?,
        event: String?,
        direction: String?,
        system: String?,
        resultTimezone: String?
    ) async throws -> ScheduleResponse
}

final class ScheduleService: ScheduleServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    /// Получить расписание по конкретной станции Яндекс.Расписаний.
    /// - Parameters:
    ///   - station: Код станции.
    ///   - lang: Язык возвращаемой информации (например, ru_RU).
    ///   - format: Формат ответа (json по умолчанию).
    ///   - date: Дата, на которую требуется расписание (формат YYYY-MM-DD).
    ///   - transportTypes: Тип транспорта (plane, train, bus и т.д.).
    ///   - event: Событие для фильтрации (arrival/отправление).
    ///   - direction: Направление (например, на Москву).
    ///   - system: Система кодирования для параметра station.
    ///   - resultTimezone: Часовой пояс для отображения времени.
    func getStationSchedule(
        station: String,
        lang: String? = nil,
        format: String? = nil,
        date: String? = nil,
        transportTypes: String? = nil,
        event: String? = nil,
        direction: String? = nil,
        system: String? = nil,
        resultTimezone: String? = nil
    ) async throws -> ScheduleResponse {
        let response = try await client.getStationSchedule(
            query: .init(
                apikey: apikey,
                station: station,
                lang: lang,
                format: format,
                date: date,
                transport_types: transportTypes,
                event: event,
                direction: direction,
                system: system,
                result_timezone: resultTimezone
            )
        )
        return try response.ok.body.json
    }
}
