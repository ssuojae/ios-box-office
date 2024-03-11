

import UIKit


final class DetailMovieViewController: UIViewController {
    
    
    private lazy var moviePosterView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
}


private extension DetailMovieViewController {
    func setupUI() {
        view.addSubview(moviePosterView)
        
        NSLayoutConstraint.activate([
            moviePosterView.trailingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.trailingAnchor, multiplier: 2.0),
            moviePosterView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2.0),
            moviePosterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            moviePosterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 100)
        ])
    }
    
    
    
    
}
