enum ErrorType {
    case serverError
    case noInternet
}

extension ErrorType: Identifiable, Sendable {
    var id: String {
        switch self {
        case .serverError: return "serverError"
        case .noInternet: return "noInternet"
        }
    }
}
