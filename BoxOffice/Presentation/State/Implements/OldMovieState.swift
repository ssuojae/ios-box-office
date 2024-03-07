import Foundation
import UIKit

class OldMovieState: releaseState {
    func showMovieRank(with cell: BoxOfficeCell) {
        cell.rankIntensityLabel.text = "고전"
        cell.rankIntensityLabel.textColor = .blue
    }
}

