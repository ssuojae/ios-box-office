
import Foundation

// MARK: - Welcome
struct KakaoImageSearchDTO: Decodable {
    let meta: Meta
    let documents: [Document]
}

// MARK: - Document
struct Document: Decodable {
    let collection: String
    let thumbnailURL: String
    let imageURL: String
    let width, height: Int
    let displaySitename: String
    let documentURL: String
    let datetime: String

    enum CodingKeys: String, CodingKey {
        case collection
        case thumbnailURL = "thumbnail_url"
        case imageURL = "image_url"
        case width, height
        case displaySitename = "display_sitename"
        case documentURL = "doc_url"
        case datetime
    }
}

// MARK: - Meta
struct Meta: Decodable {
    let totalCount, pageableCount: Int
    let isEnd: Bool

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}

// MARK: - Mapping
extension Document: kakaoMappapleTemp {
    func toEntity() -> KakaoSearchImage {
        return KakaoSearchImage(imageURL: imageURL)
    }
}
