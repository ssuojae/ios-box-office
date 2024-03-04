
import Foundation

protocol Networkmanagable {
    func bringNetworkResult<T: Decodable>(from builder: URLBuilderProtocol) async -> Result<T, NetworkError>
}

