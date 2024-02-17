
import Foundation

protocol fetchable {
    func fetchData<Element: Decodable>(_ completion: @escaping (Result<Element, NetworkError>) -> Void)
}

class NetworkManager: fetchable {
    func fetchData<Element: Decodable>(_ completion: @escaping (Result<Element, NetworkError>) -> Void) {
        let wrappedURL = URL(string: "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(ENV.API_KEY)&targetDt=20240215")
        
        guard let url = wrappedURL else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalidURL))
                return
            }
            
            guard let encodoedData = data else { 
                completion(.failure(.invalidURL))
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode(Element.self, from: encodoedData) else {
                completion(.failure(.invalidURL))
                return
            }
            completion(.success(decodedData))
        }.resume()
    }
//    func fetchData(from fileName: String, of fileType: String) throws -> Element? {
//        guard
//            let filePath = try? loadFilePath(from: fileName, of: fileType),
//            let data = try? loadFileData(from: filePath),
//            let jsonData = try? decodeFileData(from: data)
//        else {
//            return nil
//        }
//        return jsonData
//    }
//    
//    private func loadFilePath(from fileName: String, of fileType: String) throws -> String {
//        guard 
//            let filePath = Bundle.main.path(forResource: fileName, ofType: fileType)
//        else {
//            print(JsonParsingError.pathError.errorMessage)
//            throw JsonParsingError.pathError
//        }
//        return filePath
//    }
//    
//    private func loadFileData(from filePath: String) throws -> Data {
//        guard 
//            let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) 
//        else {
//            print(JsonParsingError.dataLoadError.errorMessage)
//            throw JsonParsingError.dataLoadError
//        }
//        return data
//    }
//    
//    private func decodeFileData(from fileData: Data) throws -> Element {
//        guard 
//            let jsonData = try? JSONDecoder().decode(Element.self, from: fileData)
//        else {
//            print(JsonParsingError.decodingError.errorMessage)
//            throw JsonParsingError.decodingError
//        }
//        return jsonData
//    }
}

class NetworkMockManager: fetchable {
    func fetchData<Element>(_ completion: @escaping (Result<Element, NetworkError>) -> Void) where Element : Decodable {
        let response = BoxOfficeData(boxOfficeResult: BoxOfficeResult(boxofficeType: "일별 박스오피스", showRange: "20220105~20220105", dailyBoxOfficeList: [DailyBoxOfficeList(rankNumber: "1", rank: "1", rankIntensity: "0", rankOldAndNew: RankOldAndNew.new, movieCode: "20199882", movieName: "경관의 피", openDate: "2022-01-05", salesAmount: "584559330", salesShare: "34.2", salesIntensty: "584559330", salesChange: "100", salesAccount: "631402330", audienceCount: "64050", audienceIntenstity: "64050", audienceChange: "100", audienceAccount: "69228", screenCount: "1171", showCount: "4416")]))
    }
}

