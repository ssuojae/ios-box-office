
import Foundation

protocol RequestProvidable {
    func makeRequest(requestInformation: RequestInformation) -> URLRequest?
}



