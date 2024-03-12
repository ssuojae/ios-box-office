//
//  TestViewViewController.swift
//  BoxOffice
//
//  Created by Harry Ho on 3/12/24.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let testView = TestView(frame: view.bounds)
        testView.backgroundColor = .red

        testView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        
        self.view.addSubview(testView)
        self.title = "Red View"
    }
}
