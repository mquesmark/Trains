import Foundation

/// Утилиты для работы с датой/временем, приходящими из API.
/// API может прислать дату-время как:
/// - ISO 8601: "YYYY-MM-DDThh:mm:ss±hh:mm" (или с миллисекундами)
/// - Legacy:  "YYYY-MM-DD HH:mm:ss" (через пробел)
///
/// Здесь мы:
/// - безопасно парсим в `Date?`
/// - даём форматирование для UI
/// - умеем извлекать "yyyy-MM-dd" и "HH:mm" даже если парсинг не удался
enum DateTimeHelpers {

    // MARK: - Parsers

    private static let isoWithFractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    private static let isoNoFractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    private static let legacy: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        // В legacy-формате таймзоны нет → считаем локальной.
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return f
    }()

    static func parse(_ value: String?) -> Date? {
        guard let value, !value.isEmpty else { return nil }
        if let d = isoWithFractional.date(from: value) { return d }
        if let d = isoNoFractional.date(from: value) { return d }
        return legacy.date(from: value)
    }

    // MARK: - UI formatters

    private static let yyyyMMdd: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    private static let hhmm: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "HH:mm"
        return f
    }()

    static func dateText(from date: Date?) -> String {
        guard let date else { return "" }
        return yyyyMMdd.string(from: date)
    }

    static func timeText(from date: Date?) -> String {
        guard let date else { return "" }
        return hhmm.string(from: date)
    }
    
    private static let dayMonthRu: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.timeZone = .current
        f.dateFormat = "d MMMM"
        return f
    }()

    private static let yyyyMMddParser: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    static func prettyDateText(fromYyyyMMdd raw: String?) -> String {
        guard let raw, !raw.isEmpty else { return "" }
        guard let date = yyyyMMddParser.date(from: raw) else { return raw }
        return dayMonthRu.string(from: date)
    }

    static func prettyDateText(from date: Date?) -> String {
        guard let date else { return "" }
        return dayMonthRu.string(from: date)
    }
    
    // MARK: - Fallback from raw strings

    static func dateTextFallback(from raw: String?) -> String {
        guard let raw, raw.count >= 10 else { return raw ?? "" }
        let end = raw.index(raw.startIndex, offsetBy: 10)
        return String(raw[..<end])
    }

    static func timeTextFallback(from raw: String?) -> String {
        guard let raw, !raw.isEmpty else { return "" }

        // 1) Формат date-time: "YYYY-MM-DDThh:mm:ss..." или "YYYY-MM-DD hh:mm:ss"
        if let sep = raw.firstIndex(where: { $0 == "T" || $0 == " " }) {
            let start = raw.index(after: sep)
            if raw.distance(from: start, to: raw.endIndex) >= 5 {
                let end = raw.index(start, offsetBy: 5)
                return String(raw[start..<end])
            }
        }

        // 2) Формат только времени: "HH:mm:ss" или "HH:mm"
        let parts = raw.split(separator: ":")
        if parts.count >= 2 {
            return "\(parts[0]):\(parts[1])"
        }

        return raw
    }
}
