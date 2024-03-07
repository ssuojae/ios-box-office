
class NewMovieState: releaseState {
    func showMovieRank(with cell: BoxOfficeCell) {
        cell.rankIntensityLabel.text = "신규"
        cell.rankIntensityLabel.textColor = .red
    }
}

