import Foundation

final class MovieRepository: MovieRepositoryProtocol {
    
    private let networkManager: Networkmanagable
    private let urlBuilder: URLBuilderProtocol
    private let requestBuilder: RequestBuilderProtocol

    init(networkManager: Networkmanagable, urlBuilder: URLBuilderProtocol, requestBuilder: RequestBuilderProtocol) {
        self.networkManager = networkManager
        self.urlBuilder = urlBuilder
        self.requestBuilder = requestBuilder
    }
    

    func requestBoxofficeData() async -> Result<[BoxOfficeMovie], DomainError> {
        
        guard let url = makeBoxOfficeURL(),
              let request = makeRequest(url: url) else { return .failure(.networkIssue)}
        let result: Result<BoxOfficeDTO, NetworkError> = await networkManager.bringNetworkResult(request: request)

        switch result {
        case .success(let boxOfficeDTO):
            return .success(boxOfficeDTO.boxOfficeResult.dailyBoxOfficeList.map { $0.toEntity() })
        case .failure(let networkError):
            logNetworkError(networkError)
            return .failure(networkError.mapToDomainError())
        }
    }

    func requestDetailMovieData(movie: String) async -> Result<MovieDetailInfo, DomainError> {
        
        guard let url = makeBoxOfficeURL(),
              let request = makeRequest(url: url) else { return .failure(.networkIssue)}

        let result: Result<DetailMovieInfoDTO, NetworkError> = await networkManager.bringNetworkResult(request: request)
        
        switch result {
        case .success(let detailMovieInfoDTO):
            return .success(detailMovieInfoDTO.movieInfoResult.movieInfo.toEntity())
        case .failure(let networkError):
            logNetworkError(networkError)
            return .failure(networkError.mapToDomainError())
        }
    }
    
    private func makeBoxOfficeURL() -> URL? {
        let url = urlBuilder
            .setBaseURL(type: .kobis)
            .setPath("/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json")
            .addQueryItem(name: "targetDt", value: Date().dayBefore.formattedDate(withFormat: "yyyyMMdd"))
            .setApiKey(apiKey: ENV.API_KEY)
            .build()
        
        return url
    }

    private func makeMovieDetailURL(movieCode: String) -> URL? {
        let url = urlBuilder
            .setBaseURL(type: .kobis)
            .setPath("/kobisopenapi/webservice/rest/movie/searchMovieInfo.json")
            .addQueryItem(name: "movieCd", value: movieCode)
            .setApiKey(apiKey: ENV.API_KEY)
            .build()
        
        return url
    }
    
    private func makeKakaoImageSearch(query: String) -> URL? {
        let url = urlBuilder
            .setBaseURL(type: .kakao)
            .setPath("/v2/search/image/movie/searchMovieInfo.json")
            .addQueryItem(name: "query", value: query)
            .build()
        
        return url
    }
    
    private func makeRequest(url: URL, key: String, value: String ) -> URLRequest? {
        return requestBuilder
            .setURL(url)
            .setHTTPMethod(.get)
            .addHeaderField(key: key, value: value)
            .build()
    }


    private func logNetworkError(_ error: NetworkError) {
        print("Network Error: \(error.localizedDescription)")
    }
}
