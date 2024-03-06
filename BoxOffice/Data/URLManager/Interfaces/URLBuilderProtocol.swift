
import Foundation

protocol URLBuilderProtocol {
    var baseURL: URL? { get set}
    var path: String { get set }
    var queryItems: [URLQueryItem] { get set }
    
    func setBaseURL(type: BaseURLType) -> Self
    func setPath(_ path: String) -> Self
    func addQueryItem(name: String, value: String?) -> Self
    func withApiKey(apiKey: String) -> Self
    func build() -> URL?
}


