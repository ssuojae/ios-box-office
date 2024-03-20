
import Foundation

final class MovieRepository: MovieRepositoryProtocol {
    private let sessionProvider: SessionProvidable
    private let decoder: DecoderProtocol
    
    init(sessionProvider: SessionProvidable, decoder: DecoderProtocol) {
        self.sessionProvider = sessionProvider
        self.decoder = decoder
    }
    
    func prepareBoxOfficeDataRequest<T: Decodable>() async -> T? {
        guard let request = RequestProvider(requestInformation: .dailyMovie).request else {
            return nil
        }
        return await requestAPI(request: request)
    }
    
    func prepareDetailMovieDataRequest<T: Decodable>(movieCode: String) async -> T? {
        guard let request = RequestProvider(requestInformation: .detailMovie(code: movieCode)).request else {
            return nil
        }
        return await requestAPI(request: request)
    }
    
    private func requestAPI<T: Decodable>(request: URLRequest) async -> T? {
        let result: Result<NetworkResponse, NetworkError> = await sessionProvider.requestAPI(using: request)
        
        switch result {
        case .success(let networkResponse):
            guard let data = networkResponse.data else { return nil }
            return decodeData(with: data)
            
        case .failure(let networkError):
            logNetworkError(networkError)
            return nil
        }
    }
    
    private func decodeData<T: Decodable>(with data: Data) -> T? {
        let decodingResult: Result<T, NetworkError> = decoder.decode(data)
        
        switch decodingResult {
        case .success(let decodedData):
            return decodedData
        case .failure(let error):
            // 로그로 에러처리해주고
            print(error)
            return nil
        }
    }
}

private func logNetworkError(_ error: NetworkError) {
    print("Network Error: \(error.localizedDescription)")
}



