
import Foundation

final class DependencyEnvironment {
    
    /// 디코더 설정 셋팅 예시
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }()

    private lazy var decodeProvider: JsonDecodeProtocol = JsonDecoder(jsonDecoder: jsonDecoder)

    private lazy var sessionProvider: SessionProvidable = SessionProvider()
    
    private lazy var requestBuidler: RequestBuilderProtocol = RequestBuilder()
    
    private lazy var networkManager: NetworkManagerProtocol = NetworkManager(sessionProvider: sessionProvider, decoder: decodeProvider)

    private lazy var movieRepository: MovieRepositoryProtocol = MovieRepository(networkManager: networkManager, requestBuilder: requestBuidler)
    
    private lazy var boxOfficeUseCase: BoxOfficeUseCaseProtocol = BoxOfficeUseCase(moviesRepository: movieRepository)
}

extension DependencyEnvironment: ViewControllerFactoryProtocol {
    func makeBoxOfficeCollectionViewController() -> BoxOfficeViewController {
        BoxOfficeViewController(boxOfficeUseCase: boxOfficeUseCase)
    }
}
