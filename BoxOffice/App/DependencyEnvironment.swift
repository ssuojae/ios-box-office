
import Foundation

final class DependencyEnvironment {
    
    static let shared = DependencyEnvironment()
    
    private init() {}
    
    private(set) lazy var sessionProvider: SessionProvidable = SessionProvider()
    
    private(set) lazy var decodeProvider: URLDecodeProtocol = URLDecoder()

    private(set) lazy var networkManager: Networkmanagable = {
        NetworkManager(baseURLProvider: BaseURLManager.shared, sessionProvider: sessionProvider, decoder: decodeProvider)
    }()


    private(set) lazy var movieRepository: MovieRepositoryProtocol = {
        MovieRepository(networkManager: networkManager)
    }()
    
    private(set) lazy var boxOfficeUseCase: BoxOfficeUseCaseProtocol = BoxOfficeUseCase(moviesRepository: movieRepository)
    
    func makeBoxOfficeCollectionViewController() -> BoxOfficeCollectionViewController {
        BoxOfficeCollectionViewController(boxOfficeUseCase: boxOfficeUseCase)
    }
}
