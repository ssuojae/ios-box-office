
import UIKit


final class DetailMovieViewController: UIViewController {
    
    let boxOfficeUseCase: BoxOfficeUseCase
    
    @SynchronizedLock private var movieImageView = UIImageView()
    
    init(boxOfficeUseCase: BoxOfficeUseCase) {
        self.boxOfficeUseCase = boxOfficeUseCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}



extension DetailMovieViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension DetailMovieViewController {
    
    func setupUI() {
        
    }
    
}

