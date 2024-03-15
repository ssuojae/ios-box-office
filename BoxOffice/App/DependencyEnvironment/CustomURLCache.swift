
import Foundation

final class CustomURLCache: URLCache {
    override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        if request.url?.scheme == "https" {
            storeHttpsResponse(cachedResponse, for: request)
        } else {
            storeHttpResponse(cachedResponse, for: request)
        }
    }
    
    /// 디스크 캐시 저장 허용 (
    private func storeHttpsResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        let diskAllowedCachedResponse = CachedURLResponse(response: cachedResponse.response, data: cachedResponse.data, userInfo: cachedResponse.userInfo, storagePolicy: .allowed)
        super.storeCachedResponse(diskAllowedCachedResponse, for: request)
        print("HTTPS 응답 디스크 캐시 저장 허용. URL: \(request.url?.absoluteString ?? "알 수 없음")")
    }
    
    /// 메모리에만 캐시 저장
    private func storeHttpResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        let memoryOnlyCachedResponse = CachedURLResponse(response: cachedResponse.response, data: cachedResponse.data, userInfo: cachedResponse.userInfo, storagePolicy: .allowedInMemoryOnly)
        super.storeCachedResponse(memoryOnlyCachedResponse, for: request)
        print("HTTP 응답 메모리 캐시에만 저장. URL: \(request.url?.absoluteString ?? "알 수 없음")")
    }
}
