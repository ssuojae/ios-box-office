
import Foundation


enum Section {
    case main
}

struct BoxOfficeDisplayModel: Hashable {
    var id: UUID = UUID()
    var rank: String
    var rankIntensity: String
    let isNew: Bool
    var movieName: String
    let audienceCount: String
    var audienceAccount: String
}

extension BoxOfficeDisplayModel {
    var isPlaceholder: Bool {
        return movieName == "Loading..."
    }
    
    static var placeholder: BoxOfficeDisplayModel {
        return BoxOfficeDisplayModel(rank: "", rankIntensity: "0", isNew: false, movieName: "Loading...", audienceCount: "0", audienceAccount: "0")
    }
}
