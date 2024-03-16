
import Foundation

final class RequestProvider: RequestProvidable {

    func makeRequest(requestInformation: RequestInformation) -> URLRequest? {
        guard let requestUrl = requestInformation.url else { return nil }
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = requestInformation.httpMethod
        urlRequest.allHTTPHeaderFields = requestInformation.allHTTPHeaderFields

        return urlRequest
    }
}
