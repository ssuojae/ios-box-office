
import Foundation

enum DomainError: LocalizedError {
    
    case networkIssue
    case dataUnavailable
    case unknown
    
    init(from networkError: NetworkError) {
        switch networkError {
        case .urlError, .connectivity, .timeout:
            self = .networkIssue
        case .serverError, .notFound:
            self = .dataUnavailable
        case .decodingError:
            self = .unknown
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .networkIssue:
            return NSLocalizedString("please check network status again,", comment: "")
        case .dataUnavailable:
            return NSLocalizedString("data not found", comment: "")
        case .unknown:
            return NSLocalizedString("unknown error.", comment: "")
        }
    }
}
