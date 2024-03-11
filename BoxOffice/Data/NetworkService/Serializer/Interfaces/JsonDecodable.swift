
import Foundation

//Decodable 프로토콜을 확장해서 아래 기능을 추가할 수도 있나?
protocol JsonDecodalbe {
    func decode<T: Decodable>(_ data: Data) -> Result<T, NetworkError>
}
