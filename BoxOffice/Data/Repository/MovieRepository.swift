
import Foundation

final class MovieRepository: MovieRepositoryProtocol {
    
    private let sessionProvider: SessionProvidable
    private let requestProvider: RequestProvidable
    private let decoder: DecoderProtocol
    
    init(sessionProvider: SessionProvidable, requestProvider: RequestProvidable, decoder: DecoderProtocol) {
        self.sessionProvider = sessionProvider
        self.requestProvider = requestProvider
        self.decoder = decoder
    }
    
    func requestBoxOfficeData<T: Decodable>() async -> Result<T, NetworkError> {
        guard let request = requestProvider.makeRequest(requestInformation: .dailyMovie) else {
            return .failure(.requestError)
        }
        return await makeRequestAndDecode(request: request)
    }
    
    func requestDetailMovieData<T: Decodable>(movieCode: String) async -> Result<T, NetworkError> {
        guard let request = requestProvider.makeRequest(requestInformation: .detailMovie(code: movieCode)) else {
            return .failure(.requestError)
        }
        return await makeRequestAndDecode(request: request)
    }

    private func makeRequestAndDecode<T: Decodable>(request: URLRequest) async -> Result<T, NetworkError> {
        let result: Result<NetworkResponse, NetworkError> = await sessionProvider.requestAPI(using: request)
        
        switch result {
        case .success(let networkResponse):
            guard let data = networkResponse.data else { return .failure(.connectivity) }
            print(data)
            return decoder.decode(data)
            
        case .failure(let networkError):
            logNetworkError(networkError)
            return .failure(.connectivity)
        }
    }
    
    private func logNetworkError(_ error: NetworkError) {
        print("Network Error: \(error.localizedDescription)")
    }
}
