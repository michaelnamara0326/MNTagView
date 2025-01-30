//
//  ViewController.swift
//
//
//  Created by Michael Namara on 2024/3/5.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func presentUIKitDemo(_ sender: Any) {
        let vc = UIKitDemoViewController()
        vc.title = "UIKitDemo"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func presentSwiftUIDemo(_ sender: Any) {
        let vc = UIHostingController(rootView: SwiftUIDemoView())
        vc.title = "SwiftUIDemo"
        navigationController?.pushViewController(vc, animated: true)
    }
}
