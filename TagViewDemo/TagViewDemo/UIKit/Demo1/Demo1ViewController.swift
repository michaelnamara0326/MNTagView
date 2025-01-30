//
//  Demo1ViewController.swift
//  TagViewDemo
//
//  Created by Michael Namara on 2024/4/2.
//

import UIKit
import MNTagView

let testTitlesDemo1 = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

class Demo1ViewController: UIViewController {
    @IBOutlet weak var tagListView: TagListViewUIKit!
    @IBOutlet weak var alignmentControl: UISegmentedControl!
    @IBOutlet weak var axisControl: UISegmentedControl!
    @IBOutlet weak var selectedColorControl: UISegmentedControl!
    @IBOutlet weak var textColorControl: UISegmentedControl!
    @IBOutlet weak var backgroundColorControl: UISegmentedControl!
    @IBOutlet weak var borderColorControl: UISegmentedControl!
    @IBOutlet weak var removeButtonControl: UISegmentedControl!
    @IBOutlet weak var cornerRadiusLabel: UILabel!
    @IBOutlet weak var cornerRadiusSlider: UISlider!
    @IBOutlet weak var borderWidthLabel: UILabel!
    @IBOutlet weak var borderWidthSlider: UISlider!
    @IBOutlet weak var spacingLabel: UILabel!
    @IBOutlet weak var spacingSlider: UISlider!
    @IBOutlet weak var topPaddingLabel: UILabel!
    @IBOutlet weak var topPaddingSlider: UISlider!
    @IBOutlet weak var leadingPaddingLabel: UILabel!
    @IBOutlet weak var leadingPaddingSlider: UISlider!
    @IBOutlet weak var trailingPaddingLabel: UILabel!
    @IBOutlet weak var trailingPaddingSlider: UISlider!
    @IBOutlet weak var bottomPaddingLabel: UILabel!
    @IBOutlet weak var bottomPaddingSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tagListView.delegate = self
        tagListView.addTags(titles: testTitlesDemo1)
        
        axisControl.addTarget(self, action: #selector(segementChange), for: .valueChanged)
        alignmentControl.addTarget(self, action: #selector(segementChange), for: .valueChanged)
        selectedColorControl.addTarget(self, action: #selector(segementChange), for: .valueChanged)
        textColorControl.addTarget(self, action: #selector(segementChange), for: .valueChanged)
        backgroundColorControl.addTarget(self, action: #selector(segementChange), for: .valueChanged)
        borderColorControl.addTarget(self, action: #selector(segementChange), for: .valueChanged)
        removeButtonControl.addTarget(self, action: #selector(segementChange), for: .valueChanged)
        
        cornerRadiusSlider.addTarget(self, action: #selector(sliderChange), for: .valueChanged)
        borderWidthSlider.addTarget(self, action: #selector(sliderChange), for: .valueChanged)
        spacingSlider.addTarget(self, action: #selector(sliderChange), for: .valueChanged)
        topPaddingSlider.addTarget(self, action: #selector(sliderChange), for: .valueChanged)
        leadingPaddingSlider.addTarget(self, action: #selector(sliderChange), for: .valueChanged)
        trailingPaddingSlider.addTarget(self, action: #selector(sliderChange), for: .valueChanged)
        bottomPaddingSlider.addTarget(self, action: #selector(sliderChange), for: .valueChanged)
    }
    
    @objc
    func segementChange(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch sender {
        case axisControl:
            tagListView.model.scrollAxis = index == 0 ? .none : (index == 1 ? .horizontal : .vertical)
            
        case alignmentControl:
            tagListView.model.alignment = index == 0 ? .leading : (index == 1 ? .center : .trailing)
            
        case selectedColorControl:
            tagListView.model.selectedBackgroundColor = index == 0 ? .red : (index == 1 ? .green : .blue)
            
        case textColorControl:
            tagListView.model.textColor = index == 0 ? .red : (index == 1 ? .green : .blue)
            
        case backgroundColorControl:
            tagListView.model.tagBackgroundColor = [index == 0 ? .red : (index == 1 ? .green : .blue)]
            
        case borderColorControl:
            tagListView.model.borderColor = [index == 0 ? .red : (index == 1 ? .green : .blue)]
            
        case removeButtonControl:
            tagListView.model.removeButtonEnable = index == 0 ? false : true
            
        default:
            break
        }
    }
    
    @objc
    func sliderChange(_ sender: UISlider) {
        switch sender {
        case cornerRadiusSlider:
            tagListView.model.cornerRadius = CGFloat(sender.value)
            cornerRadiusLabel.text = "Corner Radius(\(Int(sender.value)))"
            
        case borderWidthSlider:
            tagListView.model.borderWidth = CGFloat(sender.value)
            borderWidthLabel.text = "Border Width(\(Int(sender.value)))"
            
        case spacingSlider:
            tagListView.model.spacing = CGFloat(sender.value)
            spacingLabel.text = "Spacing(\(Int(sender.value)))"
            
        case topPaddingSlider:
            tagListView.model.tagPadding.top = CGFloat(sender.value)
            topPaddingLabel.text = "Top Padding(\(Int(sender.value)))"
            
        case leadingPaddingSlider:
            tagListView.model.tagPadding.leading = CGFloat(sender.value)
            leadingPaddingLabel.text = "Leading Padding(\(Int(sender.value)))"
            
        case trailingPaddingSlider:
            tagListView.model.tagPadding.trailing = CGFloat(sender.value)
            trailingPaddingLabel.text = "Trailing Padding(\(Int(sender.value)))"
            
        case bottomPaddingSlider:
            tagListView.model.tagPadding.bottom = CGFloat(sender.value)
            bottomPaddingLabel.text = "Bottom Padding(\(Int(sender.value)))"
            
        default:
            break
        }
    }
}


extension Demo1ViewController: TagViewDelegate {
    func removeButtonPressed(_ tag: TagSubView) {
        tagListView.removeTagView(tag: tag)
    }

    func tagPressed(_ tag: TagSubView) {
        tag.model.isSelected.toggle()
    }
}
