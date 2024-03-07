// Context
class MovieRankChecker {
    var movieReleaseState: releaseState
    
    init(movieReleaseState: releaseState) {
        self.movieReleaseState = movieReleaseState
    }
    
    func makeNewMovieRankLabel() {
        print("새 영화입니다.")
        self.movieReleaseState = NewMovieState()
    }
    
    func makeOldMovieRankLabel() {
        print("옛날 영화입니다.")
        self.movieReleaseState = OldMovieState()
    }
    
    func showMovieRank(with cell: BoxOfficeCell) {
        self.movieReleaseState.showMovieRank(with: cell)
    }
}
