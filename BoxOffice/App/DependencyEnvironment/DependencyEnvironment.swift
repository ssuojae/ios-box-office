
import UIKit

enum ViewControllerType {
    case boxOffice
    //case 이후뷰컨들
}

final class DependencyEnvironment {
    
    private let decoderFactory: DecoderFactory
    private let sessionFactory: SessionFactoryProtocol
    
    init(decoderFactory: DecoderFactory, sessionFactory: SessionFactoryProtocol) {
        self.decoderFactory = decoderFactory
        self.sessionFactory = sessionFactory
    }

    
    private lazy var jsonDecodeProvider: DecoderProtocol = JsonDecoder(jsonDecoder: decoderFactory.makeJsonDecoder())
    
    private lazy var sessionProvider: SessionProvidable = sessionFactory.makeSession()
    
    private lazy var requestBuidler: RequestBuilderProtocol = RequestBuilder()
    
    private lazy var networkManager: NetworkManagerProtocol = NetworkManager(sessionProvider: sessionProvider, decoder: jsonDecodeProvider)

    private lazy var movieRepository: MovieRepositoryProtocol = MovieRepository(networkManager: networkManager, requestBuilder: requestBuidler)
    
    private lazy var boxOfficeUseCase: BoxOfficeUseCaseProtocol = BoxOfficeUseCase(moviesRepository: movieRepository)
}

extension DependencyEnvironment: ViewControllerFactoryProtocol {
    func makeViewController(for type: ViewControllerType) -> UIViewController {
        switch type {
        case .boxOffice:
            return BoxOfficeViewController(boxOfficeUseCase: boxOfficeUseCase)
        }
    }
}
