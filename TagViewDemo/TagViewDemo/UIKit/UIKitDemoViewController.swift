//
//  UIKitDemoViewController.swift
//  TagViewDemo
//
//  Created by Michael Namara on 2024/4/1.
//

import UIKit
import SwiftUI // For HorizontalAlignment
import MNTagView

class UIKitDemoViewController: UIViewController {
    
    // MARK: - UI Elements
    private let previewContainer = UIView() // Pinned at top
    private let tagView = TagListViewUIKit()
    
    private let scrollView = UIScrollView() // Scrollable controls below
    private let controlsStack = UIStackView()
    
    // State
    private var tags: [String] = ["SwiftUI", "UIKit", "Layout", "Flexible", "Coding", "Apple"]
    
    // Config State (to track values for controls)
    private var currentConfig = MNTagConfig()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "UIKit Config Demo"
        
        setupPinnedLayout()
        setupPreviewArea()
        setupControls()
        
        // Initial State
        updateTagView()
    }
    
    private func setupPinnedLayout() {
        // 1. Preview Container (Pinned)
        previewContainer.backgroundColor = .secondarySystemGroupedBackground
        previewContainer.layer.shadowColor = UIColor.black.cgColor
        previewContainer.layer.shadowOpacity = 0.05
        previewContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
        previewContainer.layer.shadowRadius = 5
        previewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previewContainer)
        
        // 2. Scroll View (Controls)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // 3. Controls Stack
        controlsStack.axis = .vertical
        controlsStack.spacing = 1
        controlsStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(controlsStack)
        
        NSLayoutConstraint.activate([
            // Preview Pinned to Top
            previewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            previewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Scroll View takes remaining space
            scrollView.topAnchor.constraint(equalTo: previewContainer.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Stack View inside Scroll View
            controlsStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            controlsStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            controlsStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            controlsStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            controlsStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
    }
    
    private func setupPreviewArea() {
        let header = UILabel()
        header.text = "Interactive Preview"
        header.font = .preferredFont(forTextStyle: .headline)
        header.translatesAutoresizingMaskIntoConstraints = false
        previewContainer.addSubview(header)
        
        let tagContainer = UIView()
        tagContainer.backgroundColor = .systemGray6
        tagContainer.layer.cornerRadius = 8
        tagContainer.layer.borderWidth = 1
        tagContainer.layer.borderColor = UIColor.systemGray4.cgColor
        tagContainer.translatesAutoresizingMaskIntoConstraints = false
        previewContainer.addSubview(tagContainer)
        
        tagView.translatesAutoresizingMaskIntoConstraints = false
        tagContainer.addSubview(tagView)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: previewContainer.topAnchor, constant: 16),
            header.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor, constant: 16),
            
            tagContainer.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),
            tagContainer.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor, constant: 16),
            tagContainer.trailingAnchor.constraint(equalTo: previewContainer.trailingAnchor, constant: -16),
            tagContainer.bottomAnchor.constraint(equalTo: previewContainer.bottomAnchor, constant: -16),
            
            tagView.topAnchor.constraint(equalTo: tagContainer.topAnchor, constant: 10),
            tagView.leadingAnchor.constraint(equalTo: tagContainer.leadingAnchor, constant: 10),
            tagView.trailingAnchor.constraint(equalTo: tagContainer.trailingAnchor, constant: -10),
            tagView.bottomAnchor.constraint(equalTo: tagContainer.bottomAnchor, constant: -10),
            tagView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            tagView.heightAnchor.constraint(lessThanOrEqualToConstant: 250) // Limit height so it doesn't take full screen
        ])
        
        tagView.delegate = self
        
        // Initial Config defaults
        currentConfig.cornerRadius = 12
        currentConfig.tagBackgroundColor = .systemBlue
        currentConfig.textColor = .white
        currentConfig.selectedBackgroundColor = .systemOrange
        currentConfig.tagPadding = .init(8)
        tagView.setConfig(currentConfig)
        tagView.addTags(titles: tags)
    }
    
    private func setupControls() {
        // 1. Layout (Expanded by default)
        addExpandableSection("Layout", isExpanded: true) { stack in
            self.addSegmentedControl(to: stack, title: "Axis", items: ["Vertical", "Horizontal", "None"], index: 0) { [weak self] index in
                let axes: [TagListScrollAxis] = [.vertical, .horizontal, .none]
                self?.tagView.scrollAxis = axes[index]
            }
            self.addSegmentedControl(to: stack, title: "Alignment", items: ["Leading", "Center", "Trailing"], index: 0) { [weak self] index in
                let aligns: [TagListAlignment] = [.leading, .center, .trailing]
                self?.tagView.alignment = aligns[index]
            }
            self.addSlider(to: stack, title: "Spacing", min: 0, max: 30, value: 8) { [weak self] val in
                self?.tagView.spacing = CGFloat(val)
            }
            self.addSlider(to: stack, title: "View Padding", min: 0, max: 50, value: 0) { [weak self] val in
                 let p = CGFloat(val)
                 self?.tagView.viewPadding = UIEdgeInsets(top: p, left: p, bottom: p, right: p)
            }
        }
        
        // 2. Tag Appearance
        addExpandableSection("Tag Appearance", isExpanded: false) { stack in
            self.addSlider(to: stack, title: "Corner Radius", min: 0, max: 30, value: 12) { [weak self] val in
                self?.currentConfig.cornerRadius = CGFloat(val)
                self?.updateTagView()
            }
            self.addSlider(to: stack, title: "Text Size", min: 8, max: 24, value: 12) { [weak self] val in
                self?.currentConfig.font = .system(size: CGFloat(val))
                self?.updateTagView()
            }
            self.addSlider(to: stack, title: "Padding", min: 0, max: 20, value: 8) { [weak self] val in
                let p = CGFloat(val)
                self?.currentConfig.tagPadding = MNEdgeInsets(p)
                self?.updateTagView()
            }
        }
        
        // 3. Selection
        addExpandableSection("Selection State", isExpanded: false) { stack in
             // Just informational label for UIKit demo
             let label = UILabel()
             label.text = "Click tags to toggle selection state"
             label.font = .systemFont(ofSize: 14)
             label.textColor = .secondaryLabel
             stack.addArrangedSubview(label)
        }
        
        // 4. Remove Button
        addExpandableSection("Remove Button", isExpanded: false) { stack in
            self.addToggle(to: stack, title: "Enable Remove", isOn: false) { [weak self] isOn in
                self?.currentConfig.removeButtonEnable = isOn
                self?.updateTagView()
            }
            self.addSlider(to: stack, title: "Icon Size", min: 5, max: 20, value: 10) { [weak self] val in
                self?.currentConfig.removeButtonIconSize = CGSize(width: CGFloat(val), height: CGFloat(val))
                self?.updateTagView()
            }
        }
        
        // 5. Data
        addExpandableSection("Data", isExpanded: false) { stack in
            let btnStack = UIStackView()
            btnStack.spacing = 10
            btnStack.distribution = .fillEqually
            
            let addBtn = UIButton(type: .system)
            addBtn.setTitle("Add Tag", for: .normal)
            addBtn.backgroundColor = .systemBlue
            addBtn.setTitleColor(.white, for: .normal)
            addBtn.layer.cornerRadius = 8
            addBtn.addTarget(self, action: #selector(self.addTag), for: .touchUpInside)
            
            let clearBtn = UIButton(type: .system)
            clearBtn.setTitle("Clear All", for: .normal)
            clearBtn.backgroundColor = .systemRed
            clearBtn.setTitleColor(.white, for: .normal)
            clearBtn.layer.cornerRadius = 8
            clearBtn.addTarget(self, action: #selector(self.clearTags), for: .touchUpInside)
            
            btnStack.addArrangedSubview(addBtn)
            btnStack.addArrangedSubview(clearBtn)
            stack.addArrangedSubview(btnStack)
        }
        
        // Fill remaining space at bottom
        let spacer = UIView()
        controlsStack.addArrangedSubview(spacer)
    }
    
    private func updateTagView() {
        tagView.setConfig(currentConfig)
    }
    
    // MARK: - Expandable Section Helper
    
    private func addExpandableSection(_ title: String, isExpanded: Bool, contentBuilder: (UIStackView) -> Void) {
        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 10
        container.clipsToBounds = true
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(vStack)
        
        // Header
        let headerBtn = UIButton(type: .system)
        headerBtn.contentHorizontalAlignment = .left
        headerBtn.setTitle(title, for: .normal)
        headerBtn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        headerBtn.setTitleColor(.label, for: .normal)
        headerBtn.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        // Toggle Logic
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 15
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)
        contentStack.isHidden = !isExpanded
        
        contentBuilder(contentStack)
        
        vStack.addArrangedSubview(headerBtn)
        vStack.addArrangedSubview(contentStack)
        
        // Add action
        let action = ToggleSectionAction(stack: contentStack)
        headerBtn.addTarget(action, action: #selector(action.toggle(_:)), for: .touchUpInside)
        objc_setAssociatedObject(headerBtn, "action", action, .OBJC_ASSOCIATION_RETAIN)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: container.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        controlsStack.addArrangedSubview(container)
        // Add spacing between cards
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 10).isActive = true
        controlsStack.addArrangedSubview(spacer)
    }
    
    // MARK: - Control Helpers (Refactored to take stack)
    
    private func addSlider(to stack: UIStackView, title: String, min: Float, max: Float, value: Float, action: @escaping (Float) -> Void) {
        let hStack = UIStackView()
        hStack.spacing = 10
        
        let label = UILabel()
        label.text = title
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        
        let slider = UISlider()
        slider.minimumValue = min
        slider.maximumValue = max
        slider.value = value
        
        let valLabel = UILabel()
        valLabel.text = "\(Int(value))"
        valLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        valLabel.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        valLabel.textAlignment = .right
        valLabel.textColor = .secondaryLabel
        
        hStack.addArrangedSubview(label)
        hStack.addArrangedSubview(slider)
        hStack.addArrangedSubview(valLabel)
        
        stack.addArrangedSubview(hStack)
        
        let wrapper = SliderActionWrapper { val in
            valLabel.text = "\(Int(val))"
            action(val)
        }
        slider.addTarget(wrapper, action: #selector(wrapper.valueChanged(_:)), for: .valueChanged)
        objc_setAssociatedObject(slider, "action", wrapper, .OBJC_ASSOCIATION_RETAIN)
    }
    
    private func addSegmentedControl(to stack: UIStackView, title: String, items: [String], index: Int, action: @escaping (Int) -> Void) {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 5
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        
        let seg = UISegmentedControl(items: items)
        seg.selectedSegmentIndex = index
        
        vStack.addArrangedSubview(label)
        vStack.addArrangedSubview(seg)
        stack.addArrangedSubview(vStack)
        
        let wrapper = SegmentActionWrapper(action: action)
        seg.addTarget(wrapper, action: #selector(wrapper.valueChanged(_:)), for: .valueChanged)
        objc_setAssociatedObject(seg, "action", wrapper, .OBJC_ASSOCIATION_RETAIN)
    }
    
    private func addToggle(to stack: UIStackView, title: String, isOn: Bool, action: @escaping (Bool) -> Void) {
        let hStack = UIStackView()
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        
        let toggle = UISwitch()
        toggle.isOn = isOn
        
        hStack.addArrangedSubview(label)
        hStack.addArrangedSubview(toggle)
        stack.addArrangedSubview(hStack)
        
        let wrapper = ToggleActionWrapper(action: action)
        toggle.addTarget(wrapper, action: #selector(wrapper.valueChanged(_:)), for: .valueChanged)
        objc_setAssociatedObject(toggle, "action", wrapper, .OBJC_ASSOCIATION_RETAIN)
    }
    
    // MARK: - Actions
    @objc private func addTag() {
        let words = ["New", "Tag", "Cool", "Feature", "Demo"]
        let title = "\(words.randomElement()!) \(Int.random(in: 1...99))"
        tags.append(title)
        tagView.addTag(title: title)
    }
    
    @objc private func clearTags() {
        tags.removeAll()
        tagView.removeAllTag()
    }
}

extension UIKitDemoViewController: TagViewDelegate {
    func tagPressed(_ tag: TagSubView) {
        tag.model.isSelected.toggle()
    }
    
    func removeButtonPressed(_ tag: TagSubView) {
        if let index = tags.firstIndex(of: tag.model.title) {
            tags.remove(at: index)
        }
        tagView.removeTagView(tag: tag)
    }
}

// MARK: - Action Wrappers
class ToggleSectionAction: NSObject {
    let stack: UIStackView
    init(stack: UIStackView) { self.stack = stack }
    @objc func toggle(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.stack.isHidden.toggle()
            self.stack.alpha = self.stack.isHidden ? 0 : 1
            // Force layout update
            if sender.superview?.superview?.superview?.superview is UIScrollView {
                // Not strictly robust, but okay for demo. 
                // Better: find closest table/scroll view.
            }
        }
    }
}

class SliderActionWrapper: NSObject {
    let action: (Float) -> Void
    init(action: @escaping (Float) -> Void) { self.action = action }
    @objc func valueChanged(_ sender: UISlider) { action(sender.value) }
}

class SegmentActionWrapper: NSObject {
    let action: (Int) -> Void
    init(action: @escaping (Int) -> Void) { self.action = action }
    @objc func valueChanged(_ sender: UISegmentedControl) { action(sender.selectedSegmentIndex) }
}

class ToggleActionWrapper: NSObject {
    let action: (Bool) -> Void
    init(action: @escaping (Bool) -> Void) { self.action = action }
    @objc func valueChanged(_ sender: UISwitch) { action(sender.isOn) }
}


#Preview {
    UIKitDemoViewController()
}
