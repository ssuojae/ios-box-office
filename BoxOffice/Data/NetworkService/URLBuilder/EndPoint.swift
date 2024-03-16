
import Foundation

struct EndPoint: EndPointMakable {
    let apiHost: String
    private let urlInformation: URLInformation
    private let scheme: String = "https"
    
    init(urlInformation: URLInformation, apiHost: APIHostType) {
        self.urlInformation = urlInformation
        self.apiHost = apiHost.rawValue
    }
    
    var url: URL? {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme
        urlComponent.host = apiHost
        urlComponent.path = urlInformation.path
        urlComponent.queryItems = urlInformation.queryItems
        return urlComponent.url
    }
}
