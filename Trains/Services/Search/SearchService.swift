import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

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

enum APIHTTPError: LocalizedError {
    case undocumented(statusCode: Int, body: String?)

    var errorDescription: String? {
        switch self {
        case let .undocumented(statusCode, body):
            if let body, !body.isEmpty {
                return "HTTP \(statusCode): \(body)"
            } else {
                return "HTTP \(statusCode)"
            }
        }
    }
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
        transfers: Bool? = true
    ) async throws -> SearchSegments {
        let effectiveDate: String?
        if transfers == true {
            effectiveDate = date ?? Self.todayYyyyMMdd()
        } else {
            effectiveDate = nil
        }
        let response = try await client.getScheduleBetweenStations(
            query: .init(
                apikey: apikey,
                from: from,
                to: to,
                format: format,
                lang: lang,
                date: effectiveDate,
                transport_types: transportTypes,
                offset: offset,
                limit: limit,
                result_timezone: resultTimezone,
                transfers: transfers
            )
        )
        switch response {
        case let .ok(ok):
            return try ok.body.json

        case let .undocumented(statusCode, payload):
            var bodyText: String? = nil

            if let body = payload.body {
                do {
                    // OpenAPIRuntime даёт публичный способ «собрать» HTTPBody через init(collecting:upTo:)
                    let bytes = try await ArraySlice<UInt8>(collecting: body, upTo: 1_000_000)
                    bodyText = String(decoding: bytes, as: UTF8.self)
                } catch {
                    bodyText = "⚠️ cannot read body: \(error)"
                }
            }

            print("❌ getScheduleBetweenStations undocumented status:", statusCode)
            print("📦 body:", bodyText ?? "nil")

            throw APIHTTPError.undocumented(statusCode: statusCode, body: bodyText)
        }
    }

    private static func todayYyyyMMdd() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

/*
 тестовый запрос с пересадкой
 https://api.rasp.yandex-net.ru/v3.0/search/?apikey=b953018d-b52c-4090-af39-06b69c9096d2&from=s9623131&to=s9606096&format=json&lang=ru_RU&date=2026-01-18&transfers=true&limit=50&offset=0&system=yandex&show_systems=yandex&add_days_mask=true&result_timezone=Europe/Moscow
*/
