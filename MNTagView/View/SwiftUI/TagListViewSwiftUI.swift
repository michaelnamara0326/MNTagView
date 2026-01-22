//
//  TagListViewSwiftUI.swift
//
//
//  Created by Michael Namara on 2024/3/6.
//

import SwiftUI

public struct TagListViewSwiftUI: View, TagListViewProtocol {
    @ObservedObject public var model = TagListViewModel()
    
    // Binding support
    private var tagsBinding: Binding<[String]>?
    private var selectedBinding: Binding<Set<String>>?
    
    public init() {}
    
    public init(tags: [TagSubView]) {
        model.tags = tags
    }
    
    public init(titles: [String]) {
        addTags(titles: titles)
    }
    
    /// SwiftUI Idiomatic Init: Auto-syncs with external string array
    public init(tags: Binding<[String]>) {
        self.tagsBinding = tags
        
        // Default remove handler for binding
        self.model.onRemoveButtonPressed = { [tags] tagView in
            if let index = tags.wrappedValue.firstIndex(of: tagView.model.title) {
                tags.wrappedValue.remove(at: index)
            }
        }
        
        // Initialize tags using helper to ensure all props (including the handler we just set) are applied
        self.model.tags = tags.wrappedValue.map { title in
            self.model.createTag(title: title)
        }
    }
    
    public init(config: MNTagConfig) {
        model.setConfig(config)
    }
    
    public var body: some View {
        Group {
            switch model.scrollAxis {
            case .vertical:
                if model.limitScrollHeight != .zero {
                    ScrollView(.vertical, showsIndicators: model.showScrollIndicator) {
                        verticalContent
                    }
                    .frame(maxHeight: model.limitScrollHeight)
                } else {
                    ScrollView(.vertical, showsIndicators: model.showScrollIndicator) {
                        verticalContent
                    }
                }
                
            case .horizontal:
                ScrollView(.horizontal, showsIndicators: model.showScrollIndicator) {
                    horizontalContent
                }
                
            case .none:
                verticalContent
            }
        }
        .onChange(of: tagsBinding?.wrappedValue) { newTags in
            if let newTags = newTags {
                updateTagsFromBinding(newTags)
            }
        }
    }
    
    private func updateTagsFromBinding(_ newTags: [String]) {
        // Group existing tags by title to handle duplicates correctly
        var existingTagsMap = Dictionary(grouping: model.tags) { $0.model.title }
        
        let newViews = newTags.map { title -> TagSubView in
            // Try to pop an existing tag with the same title to reuse it (preserving its state)
            if var tags = existingTagsMap[title], !tags.isEmpty {
                let reusedTag = tags.removeFirst()
                existingTagsMap[title] = tags // Update map with remaining tags
                return reusedTag
            }
            
            // If no existing tag available, create a new one
            return model.createTag(title: title)
        }
        
        model.tags = newViews
    }
    
    private var verticalContent: some View {
        TagLayout(alignment: model.alignment, spacing: model.spacing) {
            ForEach(model.tags, id: \.self) { tagView in
                tagView
            }
        }
        .padding(model.viewPadding.swiftUIEdgeInsets)
        .background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        model.onContentSizeChange?(proxy.size)
                    }
                    .onChange(of: proxy.size) { newSize in
                        model.onContentSizeChange?(newSize)
                    }
            }
        )
    }
    
    private var horizontalContent: some View {
        HStack(spacing: model.spacing) {
            ForEach(model.tags, id: \.self) { tagView in
                tagView
            }
        }
        .padding(model.viewPadding.swiftUIEdgeInsets)
        .background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        model.onContentSizeChange?(proxy.size)
                    }
                    .onChange(of: proxy.size) { newSize in
                        model.onContentSizeChange?(newSize)
                    }
            }
        )
    }
}

// MARK: - Modern API
extension TagListViewSwiftUI {
    
    /// Apply a complete configuration object
    public func setConfig(_ config: MNTagConfig) -> Self {
        model.setConfig(config)
        return self
    }
    
    public func scrollAxis(_ axis: TagListScrollAxis) -> Self {
        model.scrollAxis = axis
        return self
    }
    
    public func spacing(_ spacing: CGFloat) -> Self {
        model.spacing = spacing
        return self
    }
    
    public func alignment(_ alignment: HorizontalAlignment) -> Self {
        model.alignment = alignment
        return self
    }
    
    /// Unified Padding Modifier
    public func viewPadding(_ padding: MNEdgeInsets) -> Self {
        model.viewPadding = padding
        return self
    }
    
    public func showScrollIndicator(_ show: Bool) -> Self {
        model.showScrollIndicator = show
        return self
    }
    
    public func maxHeight(_ height: CGFloat) -> Self {
        model.limitScrollHeight = height
        return self
    }
    
    // Callbacks
    public func onTagPressed(perform action: @escaping (TagSubView) -> Void) -> Self {
        model.onTagPressed = action
        return self
    }
    
    // Simplified callback for String binding users
    public func onTagPressed(perform action: @escaping (String) -> Void) -> Self {
        model.onTagPressed = { tagView in
            action(tagView.model.title)
        }
        return self
    }
    
    public func onRemoveTag(perform action: @escaping (TagSubView) -> Void) -> Self {
        model.onRemoveButtonPressed = { tagView in
            action(tagView)
            // If using binding, we should also try to update the binding
            if let index = self.tagsBinding?.wrappedValue.firstIndex(of: tagView.model.title) {
                self.tagsBinding?.wrappedValue.remove(at: index)
            }
        }
        return self
    }
    
    public func onContentSizeChange(perform action: @escaping (CGSize) -> Void) -> Self {
        model.onContentSizeChange = action
        return self
    }
    
    // MARK: - Styling Modifiers
    public func tagCornerRadius(_ radius: CGFloat) -> Self {
        model.cornerRadius = radius
        return self
    }
    
    public func tagTextColor(_ color: Color) -> Self {
        model.textColor = UIColor(color)
        return self
    }
    
    public func tagBackgroundColor(_ color: Color) -> Self {
        model.tagBackgroundColor = [UIColor(color)]
        return self
    }
    
    public func tagSelectedBackgroundColor(_ color: Color) -> Self {
        model.selectedBackgroundColor = UIColor(color)
        return self
    }
    
    /// Unified Padding Modifier
    public func tagPadding(_ padding: MNEdgeInsets) -> Self {
        model.tagPadding = padding
        return self
    }
    
    public func tagRemoveButtonEnable(_ enable: Bool) -> Self {
        model.removeButtonEnable = enable
        return self
    }
}

// MARK: - Deprecated / Legacy API
extension TagListViewSwiftUI {
    @available(*, deprecated, message: "Use setConfig() or individual modifiers like .scrollAxis(), .spacing() instead.")
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
        
        var config = MNTagConfig()
        config.textFontName = textFontName
        config.textSize = textSize
        config.textColor = UIColor(textColor)
        config.tagBackgroundColor = [UIColor(tagBackgroundColor)]
        config.selectedTextColor = UIColor(selectedTextColor)
        config.selectedBorderColor = UIColor(selectedBorderColor)
        config.selectedBackgroundColor = UIColor(selectedBackgroundColor)
        config.cornerRadius = cornerRadius
        config.tagPadding = MNEdgeInsets(tagPadding)
        config.borderWidth = borderWidth
        config.borderColor = [UIColor(bordercolor)]
        config.removeButtonEnable = removeButtonEnable
        config.removeButtonIconSize = removeButtonIconSize
        config.removeButtonIconColor = UIColor(removeButtonIconColor)
        
        model.setConfig(config)
        
        // These are not in MNTagConfig yet (layout props)
        model.scrollAxis = scrollAxis
        model.spacing = spacing
        model.alignment = alignment
        model.viewPadding = MNEdgeInsets(viewPadding)
        model.showScrollIndicator = showScrollIndicator
        model.limitScrollHeight = maxHeight
        
        return self
    }
}
