//
//  TagListViewUIKit.swift
//
//
//  Created by Michael Namara on 2024/3/19.
//

import Combine
import SwiftUI
import UIKit

// MARK: - UIView Setup
public class TagListViewUIKit: UIView, TagListViewProtocol {
    private var cancellables = Set<AnyCancellable>()
    private let hostingController = UIHostingController(rootView: TagListViewSwiftUI())
    private var rootView: TagListViewSwiftUI { return hostingController.rootView }
    private var hostingView: UIView { return hostingController.view }
    
    public var model: TagListViewModel { return rootView.model }
    
    public weak var delegate: TagViewDelegate? {
        didSet {
            model.delegate = delegate
        }
    }
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        hostingView.backgroundColor = .clear
        addSubview(hostingView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: topAnchor),
            hostingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        model.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.hostingView.invalidateIntrinsicContentSize()
                self?.invalidateIntrinsicContentSize()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Direct Configuration Properties (Facade)
    
    /// The tags currently displayed. Setting this replaces all tags.
    public var tags: [String] {
        get { model.tags.map { $0.model.title } }
        set {
            removeAllTag()
            addTags(titles: newValue)
        }
    }
    
    // MARK: - Layout
    public var scrollAxis: TagListScrollAxis {
        get { model.scrollAxis }
        set { model.scrollAxis = newValue }
    }
    
    public var alignment: TagListAlignment {
        get { model.alignment }
        set { model.alignment = newValue }
    }
    
    public var spacing: CGFloat {
        get { model.spacing }
        set { model.spacing = newValue }
    }
    
    public var viewPadding: UIEdgeInsets {
        get { model.viewPadding.uiEdgeInsets }
        set { model.viewPadding = MNEdgeInsets(top: newValue.top, leading: newValue.left, bottom: newValue.bottom, trailing: newValue.right) }
    }
    
    public var limitScrollHeight: CGFloat {
        get { model.limitScrollHeight }
        set { model.limitScrollHeight = newValue }
    }
    
    public var showScrollIndicator: Bool {
        get { model.showScrollIndicator }
        set { model.showScrollIndicator = newValue }
    }

    // MARK: - Appearance
    public var cornerRadius: CGFloat {
        get { model.cornerRadius }
        set { model.cornerRadius = newValue }
    }
    
    public var textColor: UIColor {
        get { model.textColor }
        set { model.textColor = newValue }
    }
    
    public var tagBackgroundColor: UIColor {
        get { model.tagBackgroundColor }
        set { model.tagBackgroundColor = newValue }
    }
    
    public var selectedBackgroundColor: UIColor {
        get { model.selectedBackgroundColor }
        set { model.selectedBackgroundColor = newValue }
    }
    
    public var selectedTextColor: UIColor {
        get { model.selectedTextColor }
        set { model.selectedTextColor = newValue }
    }
    
    public var borderWidth: CGFloat {
        get { model.borderWidth }
        set { model.borderWidth = newValue }
    }
    
    public var borderColor: UIColor {
        get { model.borderColor }
        set { model.borderColor = newValue }
    }
    
    public var tagPadding: MNEdgeInsets {
        get { model.tagPadding }
        set { model.tagPadding = newValue }
    }
    
    public var textFontName: String {
        get { model.textFontName }
        set { model.textFontName = newValue }
    }
    
    public var textSize: CGFloat {
        get { model.textSize }
        set { model.textSize = newValue }
    }
    
    // MARK: - Behavior
    public var isRemoveButtonEnabled: Bool {
        get { model.removeButtonEnable }
        set { model.removeButtonEnable = newValue }
    }
    
    public var removeButtonIconColor: UIColor {
        get { model.removeButtonIconColor }
        set { model.removeButtonIconColor = newValue }
    }
    
    public var removeButtonIconSize: CGSize {
        get { model.removeButtonIconSize }
        set { model.removeButtonIconSize = newValue }
    }
    
    // MARK: - Methods
    public func setConfig(_ config: MNTagConfig) {
        model.setConfig(config)
    }
}
