//
//  TestView.swift
//  BoxOffice
//
//  Created by Harry Ho on 3/12/24.
//

import UIKit

class TestView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.white
    }
}
