
import Foundation

final class DependencyEnvironment {
    
    static let shared = DependencyEnvironment()
    
    private init() {}
    
    private(set) lazy var sessionProvider: SessionProvidable = SessionProvider()
    
    private(set) lazy var decodeProvider: JsonDecodeProtocol = JsonDecoder(decoder: JSONDecoder())

    private(set) lazy var urlBuilder: URLBuilder = URLBuilder(baseURLProvider: BaseURLManager.shared)
    
    private(set) lazy var requestBuilder: RequestBuilderProtocol = RequestBuilder()

    private(set) lazy var networkManager: Networkmanagable = {
        NetworkManager(sessionProvider: sessionProvider, decoder: decodeProvider)
    }()

    private(set) lazy var movieRepository: MovieRepositoryProtocol = {
        MovieRepository(networkManager: networkManager, urlBuilder: urlBuilder, requestBuilder: requestBuilder)
    }()
    
    private(set) lazy var boxOfficeUseCase: BoxOfficeUseCaseProtocol = BoxOfficeUseCase(moviesRepository: movieRepository)
    
    @available(iOS 14.0, *)
    func makeBoxOfficeCollectionViewController() -> BoxOfficeViewController {
        BoxOfficeViewController(boxOfficeUseCase: boxOfficeUseCase)
    }
}
