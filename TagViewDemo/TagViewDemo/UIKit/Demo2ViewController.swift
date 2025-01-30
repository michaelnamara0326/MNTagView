//
//  Demo2ViewController.swift
//  TagViewDemo
//
//  Created by Michael Namara on 2024/4/2.
//

import UIKit
import MNTagView

let testTitlesDemo2 = ["A", "B", "C", "D", "E", "F", "G"]

class Demo2ViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var addTagTextField: UITextField!
    @IBOutlet weak var insertTagTitleTextField: UITextField!
    @IBOutlet weak var insertTagIndexTextField: UITextField!
    @IBOutlet weak var removeTagTitleTextField: UITextField!
    @IBOutlet weak var removeTagIndexTextField: UITextField!
    @IBOutlet weak var tagListView: TagListViewUIKit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tagListView.delegate = self
        tagListView.model.scrollAxis = .none
        tagListView.model.alignment = .center
        tagListView.addTags(titles: testTitlesDemo2)
        tagListView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBAction func addTagAction(_ sender: Any) {
        guard let title = addTagTextField.text else { return }
        tagListView.addTag(title: title)
        addTagTextField.text = ""
    }
    
    @IBAction func insertTagAction(_ sender: Any) {
        guard let title = insertTagTitleTextField.text, let index = Int(insertTagIndexTextField.text!) else { return }
        tagListView.insertTag(title, at: index)
        insertTagTitleTextField.text = ""
        insertTagIndexTextField.text = ""
    }
    
    @IBAction func removeTagTitleAction(_ sender: Any) {
        guard let title = removeTagTitleTextField.text else { return }
        tagListView.removeTag(title: title)
        removeTagTitleTextField.text = ""
    }
    @IBAction func removeTagIndexAction(_ sender: Any) {
        guard let index = Int(removeTagIndexTextField.text!) else { return }
        tagListView.removeTag(at: index)
        removeTagIndexTextField.text = ""
    }
    
    @IBAction func removeAllTagAction(_ sender: Any) {
        tagListView.removeAllTag()
    }
    
    @IBAction func allTagTitleAction(_ sender: Any) {
        resultLabel.text = "All Tag Title: \(tagListView.getAllTagsTitle().description)"
    }

    @IBAction func totalOfTagAction(_ sender: Any) {
        resultLabel.text = "Total Of Tag: \(tagListView.getTotalOfTag().description)"
    }
    @IBAction func totalOfRowAction(_ sender: Any) {
        resultLabel.text = "Total Of Row: \(tagListView.getTotalOfRow().description)"
    }
    @IBAction func selectedTagIndexAction(_ sender: Any) {
        resultLabel.text = "Selected Tag Index: \(tagListView.getSelectedTagsIndex().description)"
    }
    @IBAction func selectedTagTitleAction(_ sender: Any) {
        resultLabel.text = "Selected Tag Title: \(tagListView.getSelectedTagsTitle().description)"
    }
}


extension Demo2ViewController: TagViewDelegate {
    func removeButtonPressed(_ tag: TagSubView) {
        tagListView.removeTagView(tag: tag)
    }

    func tagPressed(_ tag: TagSubView) {
        tag.model.isSelected.toggle()
    }
}
