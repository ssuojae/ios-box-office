
import UIKit

class BoxOfficeCollectionViewController: UIViewController {
    
    var testData: [MovieListItem] = []
    
    struct MovieListItem: Hashable {
        let rank: String
        let rankIntensity: String
        let rankOldAndNew: RankOldAndNewDTO
        let movieTitle: String
        let audienceCount: String
        let audienceAccount: String
        let identifier = UUID()
        
        // identifier = UUID()
        // 아이템의 고유성을 보장하기 위해 Hashable 프로토콜을 구현
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        init(rank: String, rankIntensity: String, rankOldAndNew: RankOldAndNewDTO, movieTitle: String, audienceCount: String, audienceAccount: String) {
            self.rank = rank
            self.rankIntensity = rankIntensity
            self.rankOldAndNew = rankOldAndNew
            self.movieTitle = movieTitle
            self.audienceCount = audienceCount
            self.audienceAccount = audienceAccount
        }
    }
    
    lazy var items: [MovieListItem] = {
        return itemsInternal()
    }()

    // 섹션 예시
    enum Section {
        case main
    }

    
    private let usecase: BoxOfficeUseCaseProtocol
    private var boxOfficeTask: Task<Void, Never>?
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, MovieListItem>! = nil
    
    
    init(usecase: BoxOfficeUseCaseProtocol) {
        self.usecase = usecase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boxOfficeTask = Task {
            await fetchBoxOfficeData()
            await fetchDetailMovieData()
            print("동기동기동기동기동기")
            print(items)
            applyInitialSnapshot()
        }
        
        // 컬렉션 뷰와 데이터 소스 구성
        configureCollectionView()
        configureDataSource()
    }
    
    deinit {
        boxOfficeTask?.cancel()
    }
}

// MARK: - 컬렉션 뷰
extension BoxOfficeCollectionViewController {
    func itemsInternal() -> [MovieListItem] {
        return testData
    }
    
    func configureCollectionView() {
        
        // 컬렉션 뷰의 레이아웃을 생성하고, 컬렉션 뷰 초기화
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // 컬렉션 뷰를 뷰 계층에 추가
        view.addSubview(collectionView)
        
        // 셀을 등록합니다. 셀의 재사용을 위해 필요
        collectionView.register(BoxOfficeMainListCell.self, forCellWithReuseIdentifier: BoxOfficeMainListCell.reuseIdentifier)
    }
    
//    func createLayout() -> UICollectionViewLayout {
//        
//        // 플로우 레이아웃을 통해 셀의 크기와 섹션의 여백을 설정
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 100, height: 100)
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        return layout
//    }
    
    func createLayout() -> UICollectionViewLayout {
        let estimatedHeight = CGFloat(78)
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize,
                                                       subitem: item,
                                                       count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 0
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration
        <BoxOfficeMainListCell, BoxOfficeCollectionViewController.MovieListItem> { (cell, indexPath, movieItem) in
            // Populate the cell with our item description.
            cell.movieNameLabel.text = movieItem.movieTitle
            cell.rankLabel.text = movieItem.rank
            cell.rankIntensityLabel.text = movieItem.rankIntensity
            cell.audienceAccountLabel.text = movieItem.audienceAccount
            cell.showsSeparator = indexPath.item != self.testData.count
        }
        
        // Diffable Data Source를 구성합니다. 셀을 구성하는 클로저를 정의
        dataSource = UICollectionViewDiffableDataSource<Section, MovieListItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            // "cell" 식별자를 사용하여 셀을 가져오기
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    func applyInitialSnapshot() {
        
        // 초기 스냅샷을 생성하고 적용 이 단계에서는 데이터 모델을 스냅샷에 추가
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieListItem>()
        
        // 스냅샷에 섹션을 추가
        snapshot.appendSections([.main])
        
        // 스냅샷에 아이템(데이터)을 추가
        snapshot.appendItems(testData)
        
        // 변경된 스냅샷을 데이터 소스에 적용 및 UI업데이트
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

extension BoxOfficeCollectionViewController {
    
    func fetchBoxOfficeData() async {
        let result = await usecase.fetchBoxOfficeData()
        switch result {
        case .success(let data):
            print("일일 박스오피스 조회")
            print(data)
            testData = data.map { movieData in
                return MovieListItem(
                rank: movieData.rank,
                rankIntensity: movieData.rankIntensity,
                rankOldAndNew: movieData.rankOldandNew,
                movieTitle: movieData.movieTitle,
                audienceCount: movieData.audienceCount,
                audienceAccount: movieData.audienceAccount)
            }
            applyInitialSnapshot()
        case .failure(let error):
            presentError(error)
        }
    }
    
    func fetchDetailMovieData() async {
        let result = await usecase.fetchDetailMovieData()
        switch result {
        case .success(let data):
            print("영화 개별 상세 조회")
            print(data)
        case .failure(let error):
            presentError(error)
        }
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
