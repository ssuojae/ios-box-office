
import Foundation


class NetworkManager: Networkmanagable {
    
    private let baseURLProvider: BaseURLProvidable
    private let sessionProvider: SessionProvidable
    private let decoder: URLDecodeProtocol
    
    init(baseURLProvider: BaseURLProvidable, sessionProvider: SessionProvidable, decoder: URLDecodeProtocol) {
        self.baseURLProvider = baseURLProvider
        self.sessionProvider = sessionProvider
        self.decoder = decoder
    }
    
    func bringNetworkResult<T: Decodable>(from builder: URLBuilderProtocol) async -> Result<T, NetworkError> {
        guard let request = makeURLRequest(with: builder) 
        else { return .failure(.urlError) }
        
        let result = await sessionProvider.loadAPIRequest(using: request)
        
        switch result {
        case .success(let networkResponse):
            guard let data = networkResponse.data else { return .failure(.connectivity) }
            return decoder.decode(data)
        case .failure(let networkError):
            return .failure(networkError)
        }
    }
    
    private func makeURLRequest(with builder: URLBuilderProtocol) -> URLRequest? {
        guard let baseURL = baseURLProvider.get(for: builder.baseURL),
              var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) 
        else { return nil }
        
        components.path += builder.path
        components.queryItems = builder.queryItems

        guard let url = components.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
