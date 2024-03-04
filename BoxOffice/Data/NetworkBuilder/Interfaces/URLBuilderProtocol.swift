
import Foundation

protocol URLBuilderProtocol {
    var baseURL: BaseURLType { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }

}

