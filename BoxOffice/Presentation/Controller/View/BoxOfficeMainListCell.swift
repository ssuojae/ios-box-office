
import UIKit

class BoxOfficeMainListCell: UICollectionViewListCell {
    static let reuseIdentifier = "boxOfficeMainListCell"
    
    let rankLabel = UILabel()
    let rankIntensityLabel = UILabel()
    
    let movieNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let audienceAccountLabel = UILabel()
    
    let separatorView = UIView()
    var showsSeparator = true {
        didSet {
            updateSeparator()
        }
    }
    
    let horizontalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fill
            stackView.spacing = 8
            return stackView
    }()
    
    let leftStackView: UIStackView = {
        let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fill
            stackView.spacing = 0
            return stackView
    }()
    
    let middleStackView: UIStackView = {
        let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .leading
            stackView.distribution = .fillEqually
            stackView.spacing = 0
            return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BoxOfficeMainListCell {
    func configure() {
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        rankIntensityLabel.translatesAutoresizingMaskIntoConstraints = false
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        audienceAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        rankLabel.adjustsFontForContentSizeCategory = true
        rankIntensityLabel.adjustsFontForContentSizeCategory = true
        movieNameLabel.adjustsFontForContentSizeCategory = true
        audienceAccountLabel.adjustsFontForContentSizeCategory = true
        
        rankLabel.font = UIFont.systemFont(ofSize: 30.0)
        
        separatorView.backgroundColor = .opaqueSeparator
        
        leftStackView.addArrangedSubview(rankLabel)
        leftStackView.addArrangedSubview(rankIntensityLabel)
        
        middleStackView.addArrangedSubview(movieNameLabel)
        middleStackView.addArrangedSubview(audienceAccountLabel)
        
        horizontalStackView.addArrangedSubview(leftStackView)
        horizontalStackView.addArrangedSubview(middleStackView)
        
        addSubview(horizontalStackView)
        
        // horizontalStackView의 제약 조건 설정
        NSLayoutConstraint.activate([
        // horizontalStackView의 수평 중앙 정렬
        horizontalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    
        // horizontalStackView의 수직 중앙 정렬
        horizontalStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    
        // horizontalStackView의 크기를 자식 뷰에 맞게 조절
        horizontalStackView.widthAnchor.constraint(equalTo: widthAnchor),
        horizontalStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
        ])
        
        let leftStackWidthConstraint = leftStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2)
        leftStackWidthConstraint.priority = .defaultHigh
        leftStackWidthConstraint.isActive = true
        
        addSubview(separatorView)
        separatorView.heightAnchor.constraint(equalToConstant: 0.3).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        // Set the separator view just above the bottom of the cell
        separatorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    func updateSeparator() {
        separatorView.isHidden = !showsSeparator
    }
}
