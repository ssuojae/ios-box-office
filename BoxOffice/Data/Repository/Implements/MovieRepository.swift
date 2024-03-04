
import Foundation

final class MovieRepository: MovieRepositoryProtocol {
    
    private let networkManager: Networkmanagable
    
    init(networkManager: Networkmanagable) {
        self.networkManager = networkManager
    }

    func requestBoxofficeData() async -> Result<[BoxOfficeMovie], DomainError> {
        
        let boxOfficeBuilder = KobisNetworkBuilder(forDate: Date().dayBefore.formattedDate(withFormat: "yyyyMMdd"))
        let result: Result<BoxOfficeDTO, NetworkError> = await networkManager.bringNetworkResult(from: boxOfficeBuilder)

        switch result {
        case .success(let boxOfficeDTO):
            return .success(boxOfficeDTO.boxOfficeResult.dailyBoxOfficeList.map { $0.toEntity() })
        case .failure(let networkError):
            logNetworkError(networkError)
            return .failure(networkError.mapToDomainError())
        }
        
    }

    func requestDetailMovieData() async -> Result<MovieDetailInfo, DomainError> {
        let movieDetailBuilder = KobisNetworkBuilder(forCode: "20247219")
        let result: Result<DetailMovieInfoDTO, NetworkError> = await networkManager.bringNetworkResult(from: movieDetailBuilder)

        switch result {
        case .success(let detailMovieInfoDTO):
            return .success( detailMovieInfoDTO.movieInfoResult.movieInfo.toEntity() )
        case .failure(let networkError):
            logNetworkError(networkError)
            return .failure(networkError.mapToDomainError())
        }
    }
    
    private func logNetworkError(_ error: NetworkError) {
        print("Network Error: \(error.localizedDescription)")
    }
}
