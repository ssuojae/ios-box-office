import Foundation

enum URLInformation {
    case daily(date: String)
    case detail(code: String)
    case imageSearch(query: String)
    
    var path: String {
        switch self {
        case .daily:
            return "/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
        case .detail:
            return "/kobisopenapi/webservice/rest/movie/searchMovieInfo.json"
        case .imageSearch:
            return "/v2/search/image"
        }
    }
    
    var queryItems: [URLQueryItem] {
        var urlQueryItems: [URLQueryItem] = []
        
        switch self {
        case .daily(let date):
            urlQueryItems.append(URLQueryItem(name: "key", value: ENV.API_KEY))
            urlQueryItems.append(URLQueryItem(name: "targetDt", value: date))
        case .detail(let code):
            urlQueryItems.append(URLQueryItem(name: "key", value: ENV.API_KEY))
            urlQueryItems.append(URLQueryItem(name: "movieCd", value: code))
        case .imageSearch(let query):
            urlQueryItems.append(URLQueryItem(name: "query", value: query))
        }
        return urlQueryItems
    }
}
