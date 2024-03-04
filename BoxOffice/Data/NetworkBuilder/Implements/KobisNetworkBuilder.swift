

import Foundation

struct KobisNetworkBuilder: URLBuilderProtocol {
    var queryItems: [URLQueryItem]
    var baseURL: BaseURLType { .kobis }
    var path: String
    
    private static let apiKey = ENV.API_KEY
    
    init(forDate date: String) {
        self.path = "/boxoffice/searchDailyBoxOfficeList.json"
        self.queryItems = [
            URLQueryItem(name: "targetDt", value: date),
            URLQueryItem(name: "key", value: KobisNetworkBuilder.apiKey)
        ]
    }

    init(forCode code: String) {
        self.path = "/movie/searchMovieInfo.json"
        self.queryItems = [
            URLQueryItem(name: "movieCd", value: code),
            URLQueryItem(name: "key", value: KobisNetworkBuilder.apiKey)
        ]
    }
}
