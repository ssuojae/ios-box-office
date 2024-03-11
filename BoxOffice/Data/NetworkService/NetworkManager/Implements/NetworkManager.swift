
import Foundation

class NetworkManager: Networkmanagable {
    
    private let sessionProvider: SessionProvidable
    private let decoder: URLDecodeProtocol
    
    init(sessionProvider: SessionProvidable, decoder: URLDecodeProtocol) {
        self.sessionProvider = sessionProvider
        self.decoder = decoder
    }
    
    func bringNetworkResult<T: Decodable>(request: URLRequest) async -> Result<T, NetworkError> {
        
        let result = await sessionProvider.loadAPIRequest(using: request)
        
        switch result {
        case .success(let networkResponse):
            guard let data = networkResponse.data else { return .failure(.connectivity) }
            return decoder.decode(data)
        case .failure(let networkError):
            return .failure(networkError)
        }
    }
        
}
 
