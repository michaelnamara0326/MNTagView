//
//  TagListViewModel.swift
//
//
//  Created by Michael Namara on 2024/3/6.
//

import SwiftUI
import UIKit

public enum TagListScrollAxis {
    case vertical
    case horizontal
    case none
}

@MainActor
public class TagListViewModel: ObservableObject {
    var totalOfRow: Int = 0
    
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
    
    var limitScrollHeight: CGFloat = .zero
    // MARK: - Property
    /// Provide
    @Published public var tags: [TagSubView] = []
    
    @Published public var scrollAxis: TagListScrollAxis = .none
    
    /// Adjust the space that between each tag, default is 8
    @Published public var spacing: CGFloat = 8
    
    /// Alignment of tags
    @Published public var alignment: HorizontalAlignment = .leading
    
    @Published public var showScrollIndicator = true
    
    @Published public var viewPadding: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    
    /// Adjust each tag's title text color
    @Published public var textColor: UIColor = .white {
        didSet {
            tags.forEach { $0.model.textColor = textColor }
        }
    }
    
    /// Adjust each tag's title text font, default is system font and size 12
    @Published public var textFontName: String = "" {
        didSet {
            tags.forEach { $0.model.textFontName = textFontName }
        }
    }
    
    @Published public var textSize: CGFloat = 12 {
        didSet {
            tags.forEach { $0.model.textSize = textSize }
        }
    }
    
    /// Adjust each tag's background color
    /// support gradient
    @Published public var tagBackgroundColor: [UIColor] = [] {
        didSet {
            tags.forEach { $0.model.tagBackgroundColor = tagBackgroundColor }
        }
    }
    
    @Published public var selectedTextColor: UIColor = .white {
        didSet {
            tags.forEach { $0.model.selectedTextColor = selectedTextColor }
        }
    }
    
    @Published public var selectedBorderColor: UIColor = .clear {
        didSet {
            tags.forEach { $0.model.selectedBorderColor = selectedBorderColor }
        }
    }
    
    /// Adjust each tag selected background color
    @Published public var selectedBackgroundColor: UIColor = .blue {
        didSet {
            tags.forEach { $0.model.selectedBackgroundColor = selectedBackgroundColor }
        }
    }
    
    /// Adjust each tag's corner radius, default is 0
    @Published public var cornerRadius: CGFloat = 0 {
        didSet {
            tags.forEach { $0.model.cornerRadius = cornerRadius }
        }
    }

    /// Adjust tag title top padding, default is 8
    @Published public var tagPadding: EdgeInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4) {
        didSet {
            tags.forEach { $0.model.tagPadding = tagPadding }
        }
    }

    
    @Published public var borderWidth: CGFloat = 0 {
        didSet {
            tags.forEach { $0.model.borderWidth = borderWidth }
        }
    }
    
    /// support gradient
    @Published public var borderColor: [UIColor] = [] {
        didSet {
            tags.forEach { $0.model.borderColor = borderColor }
        }
    }
    
    @Published public var removeButtonEnable: Bool = false {
        didSet {
            tags.forEach { $0.model.removeButtonEnable = removeButtonEnable }
        }
    }
    
    @Published public var removeButtonIconSize: CGSize = CGSize(width: 10, height: 10) {
        didSet {
            tags.forEach { $0.model.removeButtonIconSize = removeButtonIconSize }
        }
    }
    
    @Published public var removeButtonIconColor: UIColor = .red {
        didSet {
            tags.forEach { $0.model.removeButtonIconColor = removeButtonIconColor }
        }
    }

    func createTag(title: String) -> TagSubView {
        let model = TagViewModel(title: title)
        model.delegate = delegate
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
