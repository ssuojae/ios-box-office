
import Foundation

protocol SessionFactoryProtocol {
    func makeSession() -> SessionProvidable
}

final class SessionFactory: SessionFactoryProtocol {
    func makeSession() -> SessionProvidable {
        let customCache = CustomURLCache()
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = customCache
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForResource = 5
        let session = URLSession(configuration: configuration)
        return SessionProvider(session: session)
    }
}

