
import Foundation

//https://dapi.kakao.com/v2/search/image

enum APIHost: String {
    case kobis = "www.kobis.or.kr"
    case kakao = "www.dapi.kakao.com"
}

protocol EndPointMakable {
    var url: URL? { get }
}

struct EndPoint: EndPointMakable {
    init(urlInformation: URLInformation, host: APIHost) {
        self.urlInformation = urlInformation
        self.host = host.rawValue
    }
    
    private let urlInformation: URLInformation
    private let scheme: String = "https"
    private var host: String = "www.kobis.or.kr"
    
    var url: URL? {
        var urlComponent = URLComponents()
        
        urlComponent.scheme = scheme
        urlComponent.host = host
        urlComponent.path = urlInformation.path
        urlComponent.queryItems = urlInformation.queryItems
        return urlComponent.url
    }

    enum URLInformation {
        case daily(date: String)
        case detail(date: String)
        case kakao(date: String)
        
        var path: String {
            switch self {
            case .daily:
                return "/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
            case .detail:
                return "/kobisopenapi/webservice/rest/movie/searchMovieInfo.json"
            case .kakao:
                return "/v2/search/image"
            }
        }
        
        var queryItems: [URLQueryItem] {
            var urlQueryItems = [URLQueryItem(name: "key", value: ENV.API_KEY)]
            
            switch self {
            case .daily(let date):
                urlQueryItems.append(URLQueryItem(name: "fsdf", value: date))
            case .detail(let date):
                urlQueryItems.append(URLQueryItem(name: "fsdf", value: date))
            case .kakao(let date):
                urlQueryItems.append(URLQueryItem(name: "fsdf", value: date))
            }
            
            return urlQueryItems
        }
    }
}
