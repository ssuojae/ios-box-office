
import UIKit

final class BoxOfficeCollectionViewController: UIViewController {
    
    private let service: fetchable = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    private func fetchData() {
        service.fetchData() { (result: Result<BoxOfficeData, NetworkError>) in
            switch result {
            case .success(let boxOfficeData):
                print("데이터 받아오기 성공!")
                print(boxOfficeData)
                print("데이터 호출 끝!")
            case .failure(let error):
                print(error)
            }
        }
    }
}

