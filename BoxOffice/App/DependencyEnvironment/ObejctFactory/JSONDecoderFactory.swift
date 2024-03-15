
import Foundation

protocol DecoderFactory {
    func makeJsonDecoder() -> JSONDecoder
}


final class JsonDecoderFactory: DecoderFactory {
    func makeJsonDecoder() -> JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }
}
