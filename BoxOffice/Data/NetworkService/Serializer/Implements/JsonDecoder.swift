
import Foundation

struct JsonDecoder: JsonDecodalbe {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    func decode<T: Decodable>(_ data: Data) -> Result<T, NetworkError> {
        guard let decodedData = try? decoder.decode(T.self, from: data)
        else { return .failure(.decodingError) }
        return .success(decodedData)
    }
}
