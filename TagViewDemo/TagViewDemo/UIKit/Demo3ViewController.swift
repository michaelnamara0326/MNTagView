//
//  Demo3ViewController.swift
//  TagViewDemo
//
//  Created by Michael Namara on 2024/4/3.
//

import UIKit
import MNTagView

class Demo3ViewController: UIViewController {
    @IBOutlet weak var tagListView: TagListViewUIKit!
    @IBOutlet weak var tagListHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandButton: UIButton!
    
    var isExpand = true {
        didSet {

            UIView.animate(withDuration: 1) {
                self.tagListView.isHidden = !self.isExpand
                self.tagListHeightConstraint.constant = self.isExpand ? 100 : 0
                self.view.layoutIfNeeded()
                self.expandButton.setImage(UIImage(systemName: self.isExpand ? "chevron.up" : "chevron.down"), for: .normal)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagListView.addTags(titles: testTitlesDemo2)
        
        expandButton.setTitle("", for: .normal)
        expandButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        expandButton.addTarget(self, action: #selector(handleExpand), for: .touchUpInside)
    }
    
    @objc
    func handleExpand(_ sender: Any) {
        isExpand.toggle()
        
//        UIView.animate(withDuration: 0.3) {
//            self.tagListHeightConstraint.constant = self.isExpand ? 100 : 0
//            self.tagListView.isHidden = !self.isExpand
//            self.view.layoutIfNeeded()
//        }

    }
}
