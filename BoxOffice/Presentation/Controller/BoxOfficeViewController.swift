
import UIKit

final class BoxOfficeViewController: UIViewController {
    
    private let boxOfficeUseCase: BoxOfficeUseCaseProtocol
    
    @SynchronizedLock private var movies = [BoxOfficeDisplayModel]()
    private var fetchTask: Task<Void, Never>?
    
    private var boxOfficeCollectionView: BoxOfficeCollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, BoxOfficeDisplayModel>!
    private var cellRegistration: UICollectionView.CellRegistration<BoxOfficeCell, BoxOfficeDisplayModel>!
    
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
    
    override func loadView() {
        self.boxOfficeCollectionView = BoxOfficeCollectionView(frame: .zero)
        self.view = boxOfficeCollectionView

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        fetchBoxOfficeData()
        fetchBoxOfficeDetailData()
        fetchKakaoImageSearchData()
        boxOfficeCollectionView.delegate = self

    }
}

// MARK: - Setup UI
private extension BoxOfficeViewController {
    func setupUI() {
        configureCellRegistration()
        configureNavigationBar()
        setupRefreshControl()
    }
    
    func configureNavigationBar() {
        navigationItem.title = Date().formattedDate(withFormat: "YYYY-MM-dd")
    }

    func configureCellRegistration() {
        cellRegistration = UICollectionView.CellRegistration<BoxOfficeCell, BoxOfficeDisplayModel> { (cell, indexPath, movie) in
            cell.accessories = [.disclosureIndicator()]
            cell.rankLabel.text = movie.rank
            cell.movieNameLabel.text = movie.movieName
            guard let rankIntensity = Int(movie.rankIntensity) else { return }
            cell.matchRankIntensity(of: movie.isNew, with: rankIntensity)
            cell.matchAudienceAccount(of: movie)
        }
    }

    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshBoxOfficeData), for: .valueChanged)
        boxOfficeCollectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshBoxOfficeData() {
        fetchBoxOfficeData()
    }
}

// MARK: - Fetch Data
private extension BoxOfficeViewController {
    func fetchBoxOfficeData() {
        fetchTask = Task {
            let result = await boxOfficeUseCase.fetchBoxOfficeData()
            handleBoxOfficeResult(result)
        }
        self.boxOfficeCollectionView.refreshControl?.endRefreshing()
    }
    
    func handleBoxOfficeResult(_ result: [BoxOfficeMovie]?) {
        guard let boxOfficeMovies = result else { return }
        let displayMovies = mapEntityToDisplayModel(boxOfficeMovies)
        self.movies = displayMovies
        applySnapshot(movies: displayMovies, animatingDifferences: true)
    }
    
    func fetchBoxOfficeDetailData() {
        fetchTask = Task {
            let result = await boxOfficeUseCase.fetchDetailMovieData(movie: "20236488")
            handleBoxOfficeDetailResult(result)
        }
    }
    
    func handleBoxOfficeDetailResult(_ result: MovieDetailInfo) {
            print(result)
    }
    
    func fetchKakaoImageSearchData() {
        fetchTask = Task {
            let result = await boxOfficeUseCase.fetchKakaoImageSearchData(query: "파묘 영화 포스터")
            handleBoxOfficeDetailResult(result)
        }
    }
    
    func handleBoxOfficeDetailResult(_ result: [KakaoSearchImage]) {
            print("카카오 이미지 주소")
            print(result[0])
    }
    
    @MainActor
    func presentAlert(error: DomainError) {
        self.presentAlert(title: "네트워크 오류", message: "네트워크에 문제가 있습니다 \(error)", confirmTitle: "확인")
    }
    
    func mapEntityToDisplayModel(_ boxOfficeMovies: [BoxOfficeMovie]) -> [BoxOfficeDisplayModel] {
        return boxOfficeMovies.map {
            BoxOfficeDisplayModel(
                rank: $0.rank,
                rankIntensity: $0.rankChange,
                isNew: $0.isNew,
                movieName: $0.name,
                audienceCount: $0.dalilyAudience,
                audienceAccount: $0.cumulateAudience)}
    }
}


// MARK: - Apply Diffable DataSource
private extension BoxOfficeViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, BoxOfficeDisplayModel>(collectionView: boxOfficeCollectionView) {
            (collectionView, indexPath, movie) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: movie)
        }
        let loadingPlaceholder = [BoxOfficeDisplayModel.placeholder]
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, BoxOfficeDisplayModel>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(loadingPlaceholder, toSection: .main)
        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
    func applySnapshot(movies: [BoxOfficeDisplayModel], animatingDifferences: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, BoxOfficeDisplayModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension BoxOfficeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 여기서 선택된 영화의 상세 정보를 가져오기
        let movie = movies[indexPath.row]
        
        // DetailMovieViewController 초기화 및 데이터 전달
        let detailViewController = DetailMovieViewController()
        // 여기에 필요한 데이터 전달 로직 추가,
        // detailViewController.movie = movie
        
        // 화면 전환 실행
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
