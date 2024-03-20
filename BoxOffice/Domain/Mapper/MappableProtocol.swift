
import Foundation

protocol Mappaple {
    func mapBoxOfficeMovieData() async -> [BoxOfficeMovie]
    func mapBoxOfficeDetailData(movie: String) async -> MovieDetailInfo
    func mapKakaoImageSearchData(query: String) async -> [KakaoSearchImage]
}

protocol kakaoMappapleTemp {
    associatedtype Entity
    func toEntity() -> Entity
}

protocol ErrorMappable {
    func mapToDomainError() -> DomainError
}
