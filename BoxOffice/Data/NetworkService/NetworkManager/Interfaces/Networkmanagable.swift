
import Foundation

protocol Networkmanagable {
    func bringNetworkResult<T: Decodable>(request: URLRequest) async -> Result<T, NetworkError>
}
