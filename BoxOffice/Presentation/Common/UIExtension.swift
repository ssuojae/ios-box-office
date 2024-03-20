
import UIKit

extension UILabel {
    convenience init(text: String,
                     textAlignment: NSTextAlignment = .left,
                     numberOfLines: Int = 0,
                     font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize),
                     textColor: UIColor = .black) {
        self.init()
        self.text = text
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.font = font
        self.textColor = textColor
    }
}

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis,
                     spacing: CGFloat,
                     alignment: UIStackView.Alignment,
                     distribution: UIStackView.Distribution) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
}
