
import Foundation

final class RequestBuilder: RequestBuilderProtocol {
    
    private var request: URLRequest?
    private var lastDate = Date()
        
    /// URL 설정
    func setURL(_ url: URL) -> Self {
        self.request = URLRequest(url: url)
        return self
    }
    
    /// HTTP 메소드 설정
    func setHTTPMethod(_ method: HTTPMethodType) -> Self {
        request?.httpMethod = method.rawValue
        return self
    }
    
    /// Cache 설정
    func setCachePolicy(_ cachePolicy: URLRequest.CachePolicy, forseconds seconds: Double) -> Self {
        if lastDate.timeIntervalSinceNow < -seconds {
            clearCache()
            self.request?.cachePolicy = .reloadIgnoringLocalCacheData
        } else {
            self.request?.cachePolicy = cachePolicy
        }
        return self
    }
    
    /// URLCache에서 캐시 삭제
    private func clearCache() {
        URLCache.shared.removeAllCachedResponses()
    }

    /// 와이파이 연결만 하고 싶다면 이걸로
    func setAllowsCellularAccess(_ allow: Bool) -> Self {
        request?.allowsCellularAccess = allow
        return self
    }

    // 헤더 필드 추가
    func addHeaderField(key: String, value: String) -> Self {
        request?.setValue(value, forHTTPHeaderField: key)
        return self
    }
    
    func build() -> URLRequest? {
        guard let request else { return nil }
        return request
    }
    
}
