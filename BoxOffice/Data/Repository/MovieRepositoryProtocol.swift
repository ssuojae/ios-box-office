
protocol MovieRepositoryProtocol {
    func requestBoxOfficeData<T: Decodable>() async -> T?
    func requestDetailMovieData<T: Decodable>(movieCode: String) async -> T?
    func requestKakaoImageSearchData<T: Decodable>(query: String) async -> T?
}
