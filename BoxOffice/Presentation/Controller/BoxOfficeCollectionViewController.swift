
import UIKit

class BoxOfficeCollectionViewController: UIViewController {
    
    private var movies: [MovieListItem] = []
    private let boxOfficeUseCase: BoxOfficeUseCaseProtocol
    private var fetchTask: Task<Void, Never>?
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MovieListItem>! = nil
    var cellRegistration: UICollectionView.CellRegistration<BoxOfficeMainListCell, MovieListItem>! = nil
    lazy var boxOfficeCollectionView = BoxOfficeCollectionView(frame: view.bounds)
    
    init(boxOfficeUseCase: BoxOfficeUseCaseProtocol) {
        self.boxOfficeUseCase = boxOfficeUseCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var items: [MovieListItem] = { 
        return itemsInternal()
    }()
    
    deinit { fetchTask?.cancel() }
}
    
// MARK: - 생명주기
extension BoxOfficeCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Date().formattedDate(withFormat: "YYYY-MM-dd")
        fetchBoxOfficeData()
        
        // 컬렉션 뷰와 데이터 소스 구성
        configureCollectionView()
        configureDataSource()
    }
}

// MARK: - 컬렉션 뷰
extension BoxOfficeCollectionViewController {
    func itemsInternal() -> [MovieListItem] {
        return movies
    }
    
    func configureCollectionView() {
        // 컬렉션 뷰를 뷰 계층에 추가
        view.addSubview(boxOfficeCollectionView)
        // 셀을 등록합니다. 셀의 재사용을 위해 필요
        boxOfficeCollectionView.register(BoxOfficeMainListCell.self, forCellWithReuseIdentifier: BoxOfficeMainListCell.reuseIdentifier)
    }
    
    func numberFormatter(for data: String) -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let result = numberFormatter.string(from: NSNumber(value: Double(data) ?? 0)) else { return "error" }
        return result
    }
    
    func configureDataSource() {
        cellRegistration = UICollectionView.CellRegistration
        <BoxOfficeMainListCell, MovieListItem> { (cell, indexPath, movieItem) in
            // Populate the cell with our item description.
            cell.accessories = [.disclosureIndicator()]
            cell.rankLabel.text = movieItem.rank
            cell.rankIntensityLabel.text = movieItem.rankIntensity
            cell.movieNameLabel.text = movieItem.movieTitle
            
//            numberFormatter(for: movieItem.audienceCount)
//            numberFormatter(for: movieItem.audienceAccount)
            
            
            let audienceAccountLabel: String = "오늘 \(self.numberFormatter(for: movieItem.audienceCount)) / 총 \(self.numberFormatter(for: movieItem.audienceAccount))"
            
            
            cell.audienceAccountLabel.text = audienceAccountLabel
            
            cell.showsSeparator = indexPath.item != self.movies.count
        }
        
        // Diffable Data Source를 구성합니다. 셀을 구성하는 클로저를 정의
        dataSource = UICollectionViewDiffableDataSource<Section, MovieListItem>(collectionView: boxOfficeCollectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            // "cell" 식별자를 사용하여 셀을 가져오기
            return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: item)
        }
    }
}

extension BoxOfficeCollectionViewController {
    
    func fetchBoxOfficeData() {
        fetchTask = Task {
            let result = await boxOfficeUseCase.fetchBoxOfficeData()
            handleFetchResult(result)
        }
    }
    
    func handleFetchResult(_ result: Result<[BoxOfficeMovie], DomainError>) {
        switch result {
        case .success(let boxOfficeMovies):
            let displayMovies = boxOfficeMovies.map {
                MovieListItem(rank: $0.rank,
                              rankIntensity: $0.rankIntensity,
                              rankOldAndNew: $0.rankOldandNew,
                              movieTitle: $0.movieTitle,
                              audienceCount: $0.audienceCount,
                              audienceAccount: $0.audienceAccount)
            }
            updateUI(with: .success(displayMovies))
        case .failure(let error):
            updateUI(with: .failure(error))
        }
    }
    
    func updateUI(with result: Result<[MovieListItem], DomainError>) {
        switch result {
        case .success(let movies):
            self.movies = movies // 성공 시, 영화 데이터 업데이트
            applySnapshot(movies: movies, animatingDifferences: true) // 스냅샷을 이용해 컬렉션 뷰 업데이트
        case .failure(let error):
            DispatchQueue.main.async {
                print(error)
                // Aler창 나중에 구현하기
            }
        }
    }
    
    func fetchDetailMovieData() async {
        let result = await boxOfficeUseCase.fetchDetailMovieData()
        switch result {
        case .success(let data):
            print("영화 개별 상세 조회")
            print(data)
        case .failure(let error):
            presentError(error)
        }
    }
    
    // 스냅샷을 이용해 UI 업데이트
    func applySnapshot(movies: [MovieListItem], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieListItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences) // 스냅샷 적용
    }
    
    func presentError(_ error: DomainError) {
        let message: String
        switch error {
        case .networkIssue:
            message = error.localizedDescription
        case .dataUnavailable:
            message = error.localizedDescription
        case .unknown:
            message = error.localizedDescription
        }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
