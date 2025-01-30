//
//  TagListViewSwiftUI.swift
//
//
//  Created by Michael Namara on 2024/3/6.
//

import SwiftUI

public struct TagListViewSwiftUI: View, TagListViewProtocol {
    @ObservedObject public var model = TagListViewModel()
    @State var needTrim: Bool = false
    
    public init() {}
    
    public init(tags: [TagSubView]) {
        model.tags = tags
    }
    
    public init(titles: [String]) {
        addTags(titles: titles)
    }
    
    public var body: some View {
        switch model.scrollAxis {
        case .vertical:
            Group {
                if model.limitScrollHeight != .zero {
                    if needTrim {
                        ScrollView(.vertical, showsIndicators: model.showScrollIndicator, content: getFlexibleView)
                            .frame(maxHeight: model.limitScrollHeight)
                    } else {
                        getFlexibleView()
                    }
                } else {
                    ScrollView(.vertical, showsIndicators: model.showScrollIndicator, content: getFlexibleView)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
        case .horizontal:
            ScrollView(.horizontal, showsIndicators: model.showScrollIndicator, content: getFlexibleView)
            
        case .none:
            getFlexibleView()
        }
    }
    
    private func getFlexibleView() -> some View {
        FlexibleView(
            data: model.tags,
            spacing: model.spacing,
            alignment: model.alignment,
            axis: model.scrollAxis,
            totalOfRow: $model.totalOfRow) { tagView in
                tagView
            }
            .padding(model.viewPadding)
            .readSize { size in
                needTrim = size.height > model.limitScrollHeight
                model.onContentSizeChange?(size)
            }
            .ignoresSafeArea()
    }
}

extension TagListViewSwiftUI {
    public func options(scrollAxis: TagListScrollAxis = .none,
                        textFontName: String = "",
                        textSize: CGFloat = 12,
                        textColor: Color = .white,
                        spacing: CGFloat = 8,
                        alignment: HorizontalAlignment = .leading,
                        tagBackgroundColor: Color = .gray,
                        selectedTextColor: Color = .white,
                        selectedBorderColor: Color = .clear,
                        selectedBackgroundColor: Color = .blue,
                        cornerRadius: CGFloat = 0,
                        viewPadding: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0),
                        tagPadding: EdgeInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4),
                        borderWidth: CGFloat = 0,
                        bordercolor: Color = .clear,
                        removeButtonEnable: Bool = false,
                        removeButtonIconSize: CGSize = CGSize(width: 10, height: 10),
                        removeButtonIconColor: Color = .red,
                        showScrollIndicator: Bool = false,
                        maxHeight: CGFloat = .zero) -> Self {
        model.scrollAxis = scrollAxis
        model.textFontName = textFontName
        model.textSize = textSize
        model.textColor = UIColor(textColor)
        model.spacing = spacing
        model.alignment = alignment
        model.tagBackgroundColor = [UIColor(tagBackgroundColor)]
        model.selectedTextColor = UIColor(selectedTextColor)
        model.selectedBorderColor = UIColor(selectedBorderColor)
        model.selectedBackgroundColor = UIColor(selectedBackgroundColor)
        model.cornerRadius = cornerRadius
        model.viewPadding = viewPadding
        model.tagPadding = tagPadding
        model.borderWidth = borderWidth
        model.borderColor = [UIColor(bordercolor)]
        model.removeButtonEnable = removeButtonEnable
        model.removeButtonIconSize = removeButtonIconSize
        model.removeButtonIconColor = UIColor(removeButtonIconColor)
        model.showScrollIndicator = showScrollIndicator
        model.limitScrollHeight = maxHeight
        return self
    }
    
    public func pressedTag(action: @escaping (TagSubView) -> Void) -> Self {
        model.onTagPressed = action
        return self
    }
    
    public func removeTag(action: @escaping (TagSubView) -> Void) -> Self {
        model.onRemoveButtonPressed = action
        return self
    }
    
    public func onContentSizeChange(action: @escaping (CGSize) -> Void) -> Self {
        model.onContentSizeChange = action
        return self
    }
}
