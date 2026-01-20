enum TimeIntervals: CaseIterable, Hashable, Sendable {
    case morning
    case day
    case evening
    case night
    
    var title: String {
        switch self {
        case .morning: "Утро 06:00 – 12:00"
        case .day: "День 12:00 – 18:00"
        case .evening: "Вечер 18:00 – 00:00"
        case .night: "Ночь 00:00 – 06:00"
        }
    }
    
    var range: Range<Int> {
        switch self {
        case .morning: 6..<12
        case .day: 12..<18
        case .evening: 18..<24
        case .night: 0..<6
        }
    }
}
