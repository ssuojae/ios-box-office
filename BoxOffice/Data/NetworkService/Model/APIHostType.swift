
enum APIHostType: String {
    case kobis = "www.kobis.or.kr"
    case kakao = "dapi.kakao.com"
    
    var keyValue: String {
        switch self {
        case .kobis:
            "\(ENV.API_KEY)"
        case .kakao:
            ""
        }
    }
}
