
import UIKit

class BoxOfficeCell: UICollectionViewListCell {
    
    let rankLabel = UILabel()
    let rankIntensityLabel = UILabel()
    let audienceAccountLabel = UILabel()
    let movieNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
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
    
    let rightStackView: UIStackView = {
        let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .leading
            stackView.distribution = .fillEqually
            stackView.spacing = 0
            return stackView
    }()
    
    let separatorView = UIView()
    var showsSeparator = true {
        didSet {
            updateSeparator()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BoxOfficeCell {
    
    func configureLayout() {
        configureLabels()
        configureStackViews()
        configureHorizontalStackView()
        configureSeparatorView()
    }

    private func configureLabels() {
        for label in [rankLabel, rankIntensityLabel, movieNameLabel, audienceAccountLabel] {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.adjustsFontForContentSizeCategory = true
        }

        rankLabel.font = UIFont.systemFont(ofSize: 30.0)
    }

    private func configureStackViews() {
        for stackView in [leftStackView, rightStackView, horizontalStackView] {
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 0
        }

        leftStackView.addArrangedSubview(rankLabel)
        leftStackView.addArrangedSubview(rankIntensityLabel)
        rightStackView.addArrangedSubview(movieNameLabel)
        rightStackView.addArrangedSubview(audienceAccountLabel)
        horizontalStackView.addArrangedSubview(leftStackView)
        horizontalStackView.addArrangedSubview(rightStackView)
    }

    private func configureHorizontalStackView() {
        addSubview(horizontalStackView)

        NSLayoutConstraint.activate([
            horizontalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            horizontalStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            horizontalStackView.widthAnchor.constraint(equalTo: widthAnchor),
            horizontalStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7)
        ])

        let leftStackWidthConstraint = leftStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2)
        leftStackWidthConstraint.priority = .defaultHigh
        leftStackWidthConstraint.isActive = true
    }

    private func configureSeparatorView() {
        addSubview(separatorView)

        separatorView.backgroundColor = .opaqueSeparator
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 0.3),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
    
    func updateSeparator() {
        separatorView.isHidden = !showsSeparator
    }
}
