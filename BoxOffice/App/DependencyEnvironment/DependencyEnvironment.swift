
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

    //private lazy var jsonDecodeProvider: DecoderProtocol = JsonDecoder(jsonDecoder: decoderFactory.makeJsonDecoder())
    
    private lazy var decodeProvider: DecoderProtocol = JsonDecoder(jsonDecoder: decoderFactory.makeJsonDecoder())

    private var sessionProvider: SessionProvidable = SessionProvider()

    private lazy var movieRepository: MovieRepositoryProtocol = MovieRepository(sessionProvider: sessionProvider, decoder: decodeProvider)
    
    private lazy var mapper: Mappaple = Mapper(movieRepository: movieRepository)
    
    private lazy var boxOfficeUseCase: BoxOfficeUseCaseProtocol = BoxOfficeUseCase(mapper: mapper)
}

extension DependencyEnvironment: ViewControllerFactoryProtocol {
    func makeViewController(for type: ViewControllerType) -> UIViewController {
        switch type {
        case .boxOffice:
            return BoxOfficeViewController(boxOfficeUseCase: boxOfficeUseCase)
        }
    }
}
