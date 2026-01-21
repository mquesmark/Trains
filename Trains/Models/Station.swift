import Foundation

enum StationType: String, Codable, Hashable, Sendable {
    case station
    case platform
    case stop
    case checkpoint
    case post
    case crossing
    case overtaking_point = "overtaking_point"
    case train_station = "train_station"
    case airport
    case bus_station = "bus_station"
    case bus_stop = "bus_stop"
    case unknown
    case port
    case port_point = "port_point"
    case wharf
    case river_port = "river_port"
    case marine_station = "marine_station"
}

extension StationType {
    /// SF Symbol name for displaying the station type in UI.
    /// Returns nil for `.unknown`.
    var symbolName: String? {
        switch self {
        case .airport:
            return "airplane"
        case .train_station:
            return "train.side.front.car"
        case .bus_station:
            return "bus.doubledecker"
        case .bus_stop:
            return "bus.fill"
        case .platform:
            return "rectangle.bottomthird.inset.filled"
        case .station:
            return "building.2"
        case .stop:
            return "pause.circle"
        case .checkpoint:
            return "shield.checkmark"
        case .post:
            return "signpost.right"
        case .crossing:
            return "arrow.triangle.branch"
        case .overtaking_point:
            return "arrow.left.and.right"
        case .port, .port_point:
            return "anchor"
        case .wharf:
            return "sailboat"
        case .river_port, .marine_station:
            return "ferry"
        case .unknown:
            return nil
        }
    }
}

struct Station: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let stationType: StationType
}
