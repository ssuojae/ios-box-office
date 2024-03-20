
import UIKit

class MovieDetailView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let movieImageView = UIImageView()
    private let movieInfoStackView = UIStackView(axis: .vertical, 
                                                 spacing: 8, 
                                                 alignment: .fill,
                                                 distribution: .fill)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieInfoStackView)
        
        backgroundColor = .white
        movieImageView.backgroundColor = .blue
    }
    
    func configureView(with movie: Movie) {
        movieInfoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        movie.details.forEach {
            let rowStackView = createRowStackView(title: $0.0, detail: $0.1)
            movieInfoStackView.addArrangedSubview(rowStackView)
        }

        setupConstraints()
    }
    
    private func createRowStackView(title: String, detail: String) -> UIStackView {
        
        let rowStackView = UIStackView(axis: .horizontal,
                                       spacing: 8,
                                       alignment: .firstBaseline,
                                       distribution: .fillProportionally)

        let leftLabel = UILabel(text: title,
                                textAlignment: .center,
                                numberOfLines: 1,
                                font: UIFont.boldSystemFont(ofSize: 16),
                                textColor: .black)

        
        let rightLabel = UILabel(text: detail,
                                 textAlignment: .left,
                                 numberOfLines: 0,
                                 font: UIFont.systemFont(ofSize: 14),
                                 textColor: .darkGray)

        [leftLabel, rightLabel].forEach {
            rowStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            leftLabel.widthAnchor.constraint(equalTo: rowStackView.widthAnchor, multiplier: 3.0 / 8.0),
            rightLabel.widthAnchor.constraint(equalTo: rowStackView.widthAnchor, multiplier: 5.0 / 8.0)
        ])
        
        return rowStackView
    }
    
    private func setupConstraints() {
        [scrollView,contentView,movieImageView,movieInfoStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            movieImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            movieImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 5/3),

            movieInfoStackView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 10),
            movieInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            movieInfoStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
        ])
    }
}
