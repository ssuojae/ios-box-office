
protocol MovieRepositoryProtocol {
    func requestBoxOfficeData<T: Decodable>() async -> T?
    func requestDetailMovieData<T: Decodable>(movieCode: String) async -> T?
   // func requestKaKaoImageSearch(query: String) async -> Result<[KakaoSearchImage], DomainError>
}
