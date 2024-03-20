
import Foundation

final class MovieRepository: MovieRepositoryProtocol {
    private let sessionProvider: SessionProvidable
    private let decoder: DecoderProtocol
    
    init(sessionProvider: SessionProvidable, decoder: DecoderProtocol) {
        self.sessionProvider = sessionProvider
        self.decoder = decoder
    }
    
    
    func requestBoxOfficeData<T: Decodable>() async -> T? {
        guard let request = RequestProvider(requestInformation: .dailyMovie).request else {
            return nil
        }
        return await requestAPI(request: request)
    }
    
    func requestDetailMovieData<T: Decodable>(movieCode: String) async -> T? {
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
            return decode(data)
            
        case .failure(let networkError):
            logNetworkError(networkError)
            return nil
        }
    }
    
    private func decode<T: Decodable>(_ data: Data) -> T? {
        let decodedResult: Result<T, NetworkError> = decoder.decode(data)
        
        switch decodedResult {
        case .success(let decodedData):
            return decodedData
        case .failure(_):
            return nil
        }
    }
    
    private func logNetworkError(_ error: NetworkError) {
        print("Network Error: \(error.localizedDescription)")
    }
}

//    func requestKaKaoImageSearch(query: String) async -> Result<[KakaoSearchImage], DomainError> {
//        guard let url = makeKakaoImageSearch(query: query),
//              let request = makeKakaoRequest(url: url) else { logNetworkError(.requestError); return .failure(.networkIssue) }
//
//        let result: Result<KakaoImageSearchDTO, NetworkError> = await networkManager.performRequest(from: request)
//
//        switch result {
//        case .success(let kakaoImageSearchDTO):
//            return .success(kakaoImageSearchDTO.documents.map { $0.toEntity() })
//        case .failure(let networkError):
//            logNetworkError(networkError)
//            return .failure(networkError.mapToDomainError())
//        }
//    }


//
//    private func makeKakaoImageSearch(query: String) -> URL? {
//        let url = EndPoint(urlInformation: .imageSearch(query: query), apiHost: .kakao).url
//        return url
//    }


//    private func makeRequest(url: URL) -> URLRequest? {
//        return requestBuilder
//            .setURL(url)
//            .setHTTPMethod(.get)
//            .setCachePolicy(.returnCacheDataElseLoad, forseconds: 30)
//            .build()
//    }

//    private func makeKakaoRequest(url: URL) -> URLRequest? {
//        return requestBuilder
//            .setURL(url)
//            .setHTTPMethod(.get)
//            .setCachePolicy(.returnCacheDataElseLoad, forseconds: 30)
//            .addHeaderField(key: "Authorization", value: "KakaoAK 810c0a8965ed0db2eaa292f49a4f58c2")
//            .build()
//    }
//


