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

public enum TagAlignment: String, CaseIterable {
    case leading
    case center
    case trailing
    // case justified // Justified is complex in Flow Layout (stretching items?). 
    // Usually Flow Layout "Justified" means "Space Between".
    // Let's stick to standard alignments first unless requested specifically as "Space Between".
    // The user asked for "optimization", adding Justified is a feature request I proposed.
    // Let's implement it as "Space Between" logic if selected.
    // But SwiftUI's HorizontalAlignment doesn't have it.
    // So I will create this custom Enum.
}

@MainActor
public class TagListViewModel: ObservableObject {
    
    public init() {}
    
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
    
    // Changed from HorizontalAlignment to custom TagAlignment for extensibility (though mapped for now)
    // To maintain backward compatibility, I should keep using HorizontalAlignment in the public API 
    // OR migrate.
    // Migration might be annoying for user.
    // I will keep HorizontalAlignment for now but internally I could handle more.
    // Actually, let's Stick to HorizontalAlignment to strictly follow "Simple to use".
    // Adding Justified might complicate "Simple". I will skip Justified for now to focus on Code Quality.
    @Published public var alignment: HorizontalAlignment = .leading
    
    @Published public var showScrollIndicator = true
    
    @Published public var viewPadding: MNEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    
    @Published public var textColor: UIColor = .white {
        didSet { tags.forEach { $0.model.textColor = textColor } }
    }
    
    @Published public var textFontName: String = "" {
        didSet { tags.forEach { $0.model.textFontName = textFontName } }
    }
    
    @Published public var textSize: CGFloat = 12 {
        didSet { tags.forEach { $0.model.textSize = textSize } }
    }
    
    @Published public var tagBackgroundColor: [UIColor] = [] {
        didSet { tags.forEach { $0.model.tagBackgroundColor = tagBackgroundColor } }
    }
    
    @Published public var selectedTextColor: UIColor = .white {
        didSet { tags.forEach { $0.model.selectedTextColor = selectedTextColor } }
    }
    
    @Published public var selectedBorderColor: UIColor = .clear {
        didSet { tags.forEach { $0.model.selectedBorderColor = selectedBorderColor } }
    }
    
    @Published public var selectedBackgroundColor: UIColor = .blue {
        didSet { tags.forEach { $0.model.selectedBackgroundColor = selectedBackgroundColor } }
    }
    
    @Published public var cornerRadius: CGFloat = 0 {
        didSet { tags.forEach { $0.model.cornerRadius = cornerRadius } }
    }

    @Published public var tagPadding: MNEdgeInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4) {
        didSet { tags.forEach { $0.model.tagPadding = tagPadding } }
    }

    @Published public var borderWidth: CGFloat = 0 {
        didSet { tags.forEach { $0.model.borderWidth = borderWidth } }
    }
    
    @Published public var borderColor: [UIColor] = [] {
        didSet { tags.forEach { $0.model.borderColor = borderColor } }
    }
    
    @Published public var removeButtonEnable: Bool = false {
        didSet { tags.forEach { $0.model.removeButtonEnable = removeButtonEnable } }
    }
    
    @Published public var removeButtonIconSize: CGSize = CGSize(width: 10, height: 10) {
        didSet { tags.forEach { $0.model.removeButtonIconSize = removeButtonIconSize } }
    }
    
    @Published public var removeButtonIconColor: UIColor = .red {
        didSet { tags.forEach { $0.model.removeButtonIconColor = removeButtonIconColor } }
    }

    public func setConfig(_ config: MNTagConfig) {
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
    }
    
    func createTag(title: String) -> TagSubView {
        let model = TagViewModel(title: title)
        model.delegate = delegate
        model.onTagPressed = onTagPressed
        model.onRemoveButtonPressed = onRemoveButtonPressed
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
        return TagSubView(model: model)
    }
}