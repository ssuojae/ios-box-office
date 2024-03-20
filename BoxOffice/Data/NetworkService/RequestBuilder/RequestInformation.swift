
import Foundation

enum RequestInformation {
    case dailyMovie
    case detailMovie(code: String)
    case kakaoImageSearch(query: String)
    
    var url: URL? {
        switch self {
        case .dailyMovie:
            return EndPoint(urlInformation: .daily(date: Date().dayBefore.formattedDate(withFormat: "yyyyMMdd")), apiHost: .kobis, scheme: .https).url
        case .detailMovie(let code):
            return EndPoint(urlInformation: .detail(code: code), apiHost: .kobis, scheme: .https).url
        case .kakaoImageSearch(query: let query):
            return EndPoint(urlInformation: .imageSearch(query: query), apiHost: .kakao, scheme: .https).url
        }
    }
    
    var httpMethod: String {
        switch self {
        case .dailyMovie:
            return HTTPMethodType.get.rawValue
        case .detailMovie:
            return HTTPMethodType.get.rawValue
        case .kakaoImageSearch:
            return HTTPMethodType.get.rawValue
        }
    }
    
    var allHTTPHeaderFields: [String : String] {
        switch self {
        case .dailyMovie:
            return [:]
        case .detailMovie:
            return [:]
        case .kakaoImageSearch:
            return [ "Authorization" : "KakaoAK 810c0a8965ed0db2eaa292f49a4f58c2" ]
        }
    }
}
