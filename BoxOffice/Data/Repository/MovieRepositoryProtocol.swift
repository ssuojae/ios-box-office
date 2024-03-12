
protocol MovieRepositoryProtocol {
    func requestBoxofficeData() async -> Result<[BoxOfficeMovie], DomainError>
    func requestDetailMovieData(movie: String) async -> Result<MovieDetailInfo, DomainError>
    func requestKaKaoImageSearch(query: String) async -> Result<[KakaoSearchImage], DomainError> 
}

