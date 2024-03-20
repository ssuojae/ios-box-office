
import Foundation

protocol RequestBuilderProtocol {
    func setURL(_ url: URL) -> Self
    func setHTTPMethod(_ method: HTTPMethodType) -> Self
    func setCachePolicy(_ cachePolicy: URLRequest.CachePolicy, forseconds seconds: Double) -> Self
    func addHeaderField(key: String, value: String) -> Self
    func build() -> URLRequest?
}



