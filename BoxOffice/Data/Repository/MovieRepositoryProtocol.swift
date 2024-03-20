
protocol MovieRepositoryProtocol {
    func prepareBoxOfficeDataRequest<T: Decodable>() async -> T?
    func prepareDetailMovieDataRequest<T: Decodable>(movieCode: String) async -> T?
}


