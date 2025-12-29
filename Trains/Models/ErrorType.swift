enum ErrorType {
    case serverError
    case noInternet
}

extension ErrorType: Identifiable {
    var id: String {
        switch self {
        case .serverError: return "serverError"
        case .noInternet: return "noInternet"
        }
    }
}
