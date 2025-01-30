//
//  ContainerViewController.swift
//  TagViewDemo
//
//  Created by Michael Namara on 2024/4/1.
//

import UIKit

class ContainerViewController: UIViewController {
    let demo: UIView
    
    init(demo: UIView) {
        self.demo = demo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        demo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(demo)
        NSLayoutConstraint.activate([
            demo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            demo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            demo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            demo.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
