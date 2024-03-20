
import UIKit

protocol StackViewConfigurable {
    func createStackView(withViews views: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView
}

struct StackViewFactory: StackViewConfigurable {
    func createStackView(withViews views: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.spacing = spacing
        return stackView
    }
}
