
import Foundation

enum RequestInformation {
    case dailyMovie
    case detailMovie(code: String)
    
    var url: URL? {
        switch self {
        case .dailyMovie:
            return EndPoint(urlInformation: .daily(date: Date().dayBefore.formattedDate(withFormat: "yyyyMMdd")), apiHost: .kobis).url
        case .detailMovie(let code):
            return EndPoint(urlInformation: .detail(code: code), apiHost: .kobis).url
        }
    }
    
    var httpMethod: String {
        switch self {
        case .dailyMovie:
            return HTTPMethodType.get.rawValue
        case .detailMovie:
            return HTTPMethodType.get.rawValue
        }
    }
    
    var allHTTPHeaderFields: [String : String] {
        switch self {
        case .dailyMovie:
            return [:]
        case .detailMovie:
            return [:]
        }
    }
}
