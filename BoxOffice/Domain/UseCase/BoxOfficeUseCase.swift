
import Foundation

final class BoxOfficeUseCase: BoxOfficeUseCaseProtocol {
    private let mapper: Mappaple
    
    init(mapper: Mappaple) {
        self.mapper = mapper
    }
    
    func fetchBoxOfficeData() async -> [BoxOfficeMovie] {
        return await mapper.mapBoxOfficeMovieData()
    }
    
    func fetchDetailMovieData(movie: String) async -> MovieDetailInfo {
        return await mapper.mapBoxOfficeDetailData(movie: movie)
    }
    
    func fetchKakaoImageSearchData(query: String) async -> [KakaoSearchImage] {
        return await mapper.mapKakaoImageSearchData(query: query)
    }
}

