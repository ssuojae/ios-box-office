//import UIKit
//
//class BoxOfficeView: UIView {
//    lazy var collectionView: UICollectionView = makeCollectionView()
//    var dataSource: UICollectionViewDiffableDataSource<Section, BoxOfficeDisplayModel>!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupCollectionView()
//        configureDataSource()
//        registerCells()
//    }
//
//    required init?(coder: NSCoder) { fatalError() }
//
//    private func makeCollectionView() -> UICollectionView {
//        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
//            var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//            config.leadingSwipeActionsConfigurationProvider = { [unowned self] indexPath in
//                // Example for swipe action
//                return self.contextualSwipeActions(forItemAt: indexPath)
//            }
//            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
//        }
//        return UICollectionView(frame: .zero, collectionViewLayout: layout)
//    }
//
//    private func setupCollectionView() {
//        addSubview(collectionView)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
//        ])
//        collectionView.backgroundColor = .systemBackground
//    }
//
//    private func configureDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<Section, BoxOfficeDisplayModel>(collectionView: collectionView) { (collectionView, indexPath, model) -> UICollectionViewCell? in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoxOfficeCell", for: indexPath) as? BoxOfficeCell
//            cell?.configure(with: model)
//            return cell
//        }
//    }
//
//    private func registerCells() {
//        collectionView.register(BoxOfficeCell.self, forCellWithReuseIdentifier: "BoxOfficeCell")
//    }
//
//    func update(with models: [BoxOfficeDisplayModel], animating: Bool = true) {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, BoxOfficeDisplayModel>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(models, toSection: .main)
//        dataSource.apply(snapshot, animatingDifferences: animating)
//    }
//
//    private func contextualSwipeActions(forItemAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        nil
//    }
//}
//
//extension BoxOfficeView {
//    func modelForItemAt(indexPath: IndexPath) -> BoxOfficeDisplayModel? {
//        // dataSource의 현재 스냅샷에서 모델 데이터를 가져오기
//        let snapshot = dataSource.snapshot()
//        let sectionIdentifiers = snapshot.sectionIdentifiers
//        guard sectionIdentifiers.count > indexPath.section else { return nil }
//        let items = snapshot.itemIdentifiers(inSection: sectionIdentifiers[indexPath.section])
//        return items.count > indexPath.row ? items[indexPath.row] : nil
//    }
//}
