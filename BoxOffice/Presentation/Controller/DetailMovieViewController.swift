
import UIKit

final class DetailMovieViewController: UIViewController {
    
    private var movieDetailView = MovieDetailView()
    
    override func loadView() {
        view = movieDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movie = Movie(title: "영화 제목", details: [
            ("감독", "홍길동"),
            ("출연", "주연 배우주연 배우주주연 배우주연 배우주연주연 배우주연 배우주연주연 배우주연 배우주연주연 배우주연 배우주연주연 배우주연 배우주연주연 배우주연 배우주연주연 배우주연 배우주연연 배우..."),
            ("장르", "액션"),
            ("개봉일", "2020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-012020-01-01"),
            ("상영시간", "120분"),
            ("등급", "15세 이상 관람가"),
            ("제작국가", "한국"),
            ("언어", "한국어")
        ])
        movieDetailView.configureView(with: movie)
    }
}
