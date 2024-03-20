
import Foundation

protocol Mappaple {
    func mapBoxOfficeMovieData() async -> [BoxOfficeMovie]
    func mapBoxOfficeDetailData(movie: String) async -> MovieDetailInfo
}

protocol kakaoMappapleTemp {
    associatedtype Entity
    func toEntity() -> Entity
}

protocol ErrorMappable {
    func mapToDomainError() -> DomainError
}
