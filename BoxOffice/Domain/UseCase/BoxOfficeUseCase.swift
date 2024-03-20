
import Foundation

final class BoxOfficeUseCase: BoxOfficeUseCaseProtocol {
    private let moviesRepository: MovieRepositoryProtocol
    private let mapper: Mapper
    
    init(moviesRepository: MovieRepositoryProtocol) {
        self.moviesRepository = moviesRepository
        self.mapper = Mapper(movieRepository: self.moviesRepository)
    }
    
    func fetchBoxOfficeData() async -> [BoxOfficeMovie] {
        return await mapper.mapBoxOfficeMovieData()
    }
    
    func fetchDetailMovieData(movie: String) async -> MovieDetailInfo {
        return await mapper.mapBoxOfficeDetailData(movie: movie)
    }
}
