//
//  TagListViewModel.swift
//
//
//  Created by Michael Namara on 2024/3/6.
//

import SwiftUI
import UIKit

public enum TagListScrollAxis: CaseIterable {
    case vertical
    case horizontal
    case none
}

public enum TagListAlignment: String, CaseIterable {
    case leading
    case center
    case trailing
    
    var value: HorizontalAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }
}

@MainActor
public class TagListViewModel: ObservableObject {
    
    public init() {}
    
    private var isBatchUpdating = false
    
    weak var delegate: TagViewDelegate? {
        didSet {
            tags.forEach { $0.model.delegate = delegate }
        }
    }
    
    var onTagPressed: ((TagSubView) -> Void)? {
        didSet {
            tags.forEach { $0.model.onTagPressed = onTagPressed }
        }
    }
    
    var onRemoveButtonPressed: ((TagSubView) -> Void)? {
        didSet {
            tags.forEach { $0.model.onRemoveButtonPressed = onRemoveButtonPressed }
        }
    }
    
    var onContentSizeChange: ((CGSize) -> Void)?
    
    @Published public var limitScrollHeight: CGFloat = .zero
    
    // MARK: - Property
    @Published public var tags: [TagSubView] = []
    
    @Published public var scrollAxis: TagListScrollAxis = .none
    
    @Published public var spacing: CGFloat = 8
    
    @Published public var alignment: TagListAlignment = .leading
    
    @Published public var showScrollIndicator = true
    
    @Published public var viewPadding: MNEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    
    @Published public var textColor: UIColor = .white {
        didSet { if !isBatchUpdating { tags.forEach { $0.model.textColor = textColor } } }
    }
    
    @Published public var textFontName: String = "" {
        didSet { if !isBatchUpdating { tags.forEach { $0.model.textFontName = textFontName } } }
    }
    
    @Published public var textSize: CGFloat = 12 {
        didSet { if !isBatchUpdating { tags.forEach { $0.model.textSize = textSize } } }
    }
    
    @Published public var tagBackgroundColor: UIColor = .gray {
        didSet { if !isBatchUpdating { tags.forEach { $0.model.tagBackgroundColor = tagBackgroundColor } } }
    }
    
    @Published public var selectedTextColor: UIColor = .white {
        didSet { if !isBatchUpdating { tags.forEach { $0.model.selectedTextColor = selectedTextColor } } }
    }
    
    @Published public var selectedBorderColor: UIColor = .clear {
        didSet { if !isBatchUpdating { tags.forEach { $0.model.selectedBorderColor = selectedBorderColor } } }
    }
    
    @Published public var selectedBackgroundColor: UIColor = .blue {
        didSet { if !isBatchUpdating { tags.forEach { $0.model.selectedBackgroundColor = selectedBackgroundColor } } }
    }
    
    @Published public var cornerRadius: CGFloat = 0 {
        didSet { if !isBatchUpdating { tags.forEach { $0.model.cornerRadius = cornerRadius } } }
    }

    @Published public var tagPadding: MNEdgeInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4) {
        didSet { if !isBatchUpdating { tags.forEach { $0.model.tagPadding = tagPadding } } }
    }

    @Published public var borderWidth: CGFloat = 0 {
        didSet { if !isBatchUpdating { tags.forEach { $0.model.borderWidth = borderWidth } } }
    }
    
    @Published public var borderColor: UIColor = .clear {
        didSet { if !isBatchUpdating { tags.forEach { $0.model.borderColor = borderColor } } }
    }
    
    @Published public var removeButtonEnable: Bool = false {
        didSet { if !isBatchUpdating { tags.forEach { $0.model.removeButtonEnable = removeButtonEnable } } }
    }
    
    @Published public var removeButtonIconSize: CGSize = CGSize(width: 10, height: 10) {
        didSet { if !isBatchUpdating { tags.forEach { $0.model.removeButtonIconSize = removeButtonIconSize } } }
    }
    
    @Published public var removeButtonIconColor: UIColor = .red {
        didSet { if !isBatchUpdating { tags.forEach { $0.model.removeButtonIconColor = removeButtonIconColor } } }
    }

    public func setConfig(_ config: MNTagConfig) {
        // Start batch update mode to suppress individual property observers
        isBatchUpdating = true
        defer { isBatchUpdating = false }
        
        self.cornerRadius = config.cornerRadius
        self.textColor = config.textColor
        self.textFontName = config.textFontName
        self.textSize = config.textSize
        self.tagPadding = config.tagPadding
        self.tagBackgroundColor = config.tagBackgroundColor
        self.selectedTextColor = config.selectedTextColor
        self.selectedBackgroundColor = config.selectedBackgroundColor
        self.selectedBorderColor = config.selectedBorderColor
        self.borderWidth = config.borderWidth
        self.borderColor = config.borderColor
        self.removeButtonEnable = config.removeButtonEnable
        self.removeButtonIconSize = config.removeButtonIconSize
        self.removeButtonIconColor = config.removeButtonIconColor
        
        // Single pass update for all tags
        tags.forEach { tag in
            applyStyle(to: tag.model)
        }
    }
    
    func createTag(title: String) -> TagSubView {
        let model = TagViewModel(title: title)
        model.delegate = delegate
        model.onTagPressed = onTagPressed
        model.onRemoveButtonPressed = onRemoveButtonPressed
        applyStyle(to: model)
        return TagSubView(model: model)
    }
    
    private func applyStyle(to model: TagViewModel) {
        model.cornerRadius = cornerRadius
        model.textColor = textColor
        model.borderWidth = borderWidth
        model.borderColor = borderColor
        model.tagPadding = tagPadding
        model.tagBackgroundColor = tagBackgroundColor
        model.selectedBackgroundColor = selectedBackgroundColor
        model.selectedBorderColor = selectedBorderColor
        model.textFontName = textFontName
        model.textSize = textSize
        model.removeButtonEnable = removeButtonEnable
        model.removeButtonIconSize = removeButtonIconSize
        model.removeButtonIconColor = removeButtonIconColor
    }
}
