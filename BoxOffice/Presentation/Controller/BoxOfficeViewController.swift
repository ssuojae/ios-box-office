
import UIKit


@available(iOS 14.0, *)
final class BoxOfficeViewController: UIViewController {
    
    private let boxOfficeUseCase: BoxOfficeUseCaseProtocol
    
    @MainActor private var movies: [BoxOfficeDisplayModel] = [] // 영화 데이터를 저장할 배열
    private var fetchTask: Task<Void, Never>?
    
    private var boxOfficeView: BoxOfficeCollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, BoxOfficeDisplayModel>! // 데이터 소스
    private var cellRegistration: UICollectionView.CellRegistration<BoxOfficeCell, BoxOfficeDisplayModel>! // 셀 등록
    
    init(boxOfficeUseCase: BoxOfficeUseCaseProtocol) {
        self.boxOfficeUseCase = boxOfficeUseCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        fetchTask?.cancel()
        print("\(Self.description()) \(#function)")
    }
}


// MARK: - 생명주기
extension BoxOfficeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureDataSource()
        fetchBoxOfficeData() // 데이터 가져오기
        setupRefreshControl()
    }
    
    
}

// MARK: - Refresh
private extension BoxOfficeViewController {
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshBoxOfficeData), for: .valueChanged)
        boxOfficeView.refreshControl = refreshControl
    }
    
    @objc private func refreshBoxOfficeData() {
        fetchBoxOfficeData()
    }
}


// MARK: - Setup UI
private extension BoxOfficeViewController {
    
    private func setupUI() {
        setupBoxOfficeView()
        configureCellRegistration()
        configureNavigationBar()
    }
    
    // 커스텀 뷰 설정
    private func setupBoxOfficeView() {
        boxOfficeView = BoxOfficeCollectionView(frame: view.bounds)
        configureCellRegistration() // 셀 등록 설정
        view.addSubview(boxOfficeView)
    }
    
    // 셀 등록 설정 메서드
    private func configureCellRegistration() {
        cellRegistration = UICollectionView.CellRegistration<BoxOfficeCell, BoxOfficeDisplayModel> { (cell, indexPath, movie) in
            cell.accessories = [.disclosureIndicator()]
            cell.rankLabel.text = movie.rank
            cell.rankIntensityLabel.text = movie.rankIntensity
            cell.movieNameLabel.text = movie.movieName
            
            let audienceAccountLabel: String = "오늘 \(self.numberFormatter(for: movie.audienceCount)) / 총 \(self.numberFormatter(for: movie.audienceAccount))"
            
            cell.audienceAccountLabel.text = audienceAccountLabel
        }
    }
    
    // 셀 등록 설정 메서드
    private func configureNavigationBar() {
        navigationItem.title = Date().formattedDate(withFormat: "YYYY-MM-dd")
    }
    
    private func numberFormatter(for data: String) -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let result = numberFormatter.string(from: NSNumber(value: Double(data) ?? 0)) else { return "error" }
        return result
    }
}

// MARK: - Fetch Data
private extension BoxOfficeViewController {
    func fetchBoxOfficeData() {
        fetchTask = Task {
            let result = await boxOfficeUseCase.fetchBoxOfficeData()
            handleFetchResult(result)
        }
    }
    
    func handleFetchResult(_ result: Result<[BoxOfficeMovie], DomainError>) {
        boxOfficeView.refreshControl?.endRefreshing() // 데이터 가져오면 리프레시 종료
        switch result {
        case .success(let boxOfficeMovies):
            let displayMovies = mapEntityToDisplayModel(boxOfficeMovies)
            updateUI(with: .success(displayMovies))
        case .failure(let error):
            updateUI(with: .failure(error))
        }
    }
    
    func mapEntityToDisplayModel(_ boxOfficeMovies: [BoxOfficeMovie]) -> [BoxOfficeDisplayModel] {
        return boxOfficeMovies.map { 
            BoxOfficeDisplayModel(
                rank: $0.rank,
                rankIntensity: $0.rankChange, 
                rankOldAndNew: $0.isNew,
                movieName: $0.name,
                audienceCount: $0.dalilyAudience,
                audienceAccount: $0.cumulateAudience)}
    }
}

// MARK: - Update UI
private extension BoxOfficeViewController {
    // 결과에 따라 UI 업데이트
    @MainActor
    func updateUI(with result: Result<[BoxOfficeDisplayModel], DomainError>) {
        switch result {
        case .success(let movies):
            self.movies = movies // 성공 시, 영화 데이터 업데이트
            applySnapshot(movies: movies, animatingDifferences: true) // 스냅샷을 이용해 컬렉션 뷰 업데이트
        case .failure(let error):
            print(error)
            // Aler창 나중에 구현하기
            
        }
    }
}


// MARK: - Apply Diffable DataSource
private extension BoxOfficeViewController {
    
    // 데이터 소스 설정 메서드
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, BoxOfficeDisplayModel>(collectionView: boxOfficeView) {
            (collectionView, indexPath, movie) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: movie)
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, BoxOfficeDisplayModel>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems([], toSection: .main)
        dataSource.apply(initialSnapshot, animatingDifferences: false) // 초기 스냅샷 적용
    }
    
    // 스냅샷을 이용해 UI 업데이트
    func applySnapshot(movies: [BoxOfficeDisplayModel], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, BoxOfficeDisplayModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences) // 스냅샷 적용
    }
}

