
protocol MovieRepositoryProtocol {
    func requestBoxofficeData() async -> Result<[BoxOfficeMovie], DomainError>
    func requestDetailMovieData() async -> Result<MovieDetailInfo, DomainError>
}

