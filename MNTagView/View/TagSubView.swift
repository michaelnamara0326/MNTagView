//
//  TagSubView.swift
//
//
//  Created by Michael Namara on 2024/4/1.
//

import SwiftUI

public protocol TagViewDelegate: AnyObject {
    func tagPressed(_ tag: TagSubView)
    func removeButtonPressed(_ tag: TagSubView)
}

public struct TagSubView: View {
    @ObservedObject public var model: TagViewModel

    public init(model: TagViewModel) {
        self.model = model
    }
    
    public init(title: String, isSelected: Bool = false, customData: Any? = nil) {
        self.model = TagViewModel(title: title, isSelected: isSelected, customData: customData)
    }
    
    public var body: some View {
        tag
    }
    
    @ViewBuilder
    private var tag: some View {
        let isEnabled = model.removeButtonEnable
        Button(action: pressedTag) {
            HStack {
                if let image = model.customImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: model.customImageSize.width, height: model.customImageSize.height)
                }
                
                Text(model.title)
                    .font(.custom(model.textFontName, size: model.textSize))
                    .foregroundColor(model.isSelected ? Color(model.selectedTextColor) : Color(model.textColor))
                
                if isEnabled {
                    Button(action: pressedRemoveButton) {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color(model.removeButtonIconColor))
                            .frame(width: model.removeButtonIconSize.width,
                                   height: model.removeButtonIconSize.height)
                    }
                }
            }
            .padding(model.tagPadding.swiftUIEdgeInsets)
            .background(getBackgroundColor())
            .overlay(
                RoundedRectangle(cornerRadius: model.cornerRadius)
                    .inset(by: 0.5)
                    .stroke(getStrokeColor(), lineWidth: model.borderWidth)
            )
            .cornerRadius(model.cornerRadius)
        }
        .buttonStyle(NoTapAnimationStyle())
    }
    
    private func pressedTag() {
        if let delegate = model.delegate { // for UIKit
            delegate.tagPressed(self)
        } else if let tagPressed = model.onTagPressed { // for SwiftUI
            tagPressed(self)
        }
    }

    private func pressedRemoveButton() {
        if let delegate = model.delegate {// for UIKit
            delegate.removeButtonPressed(self)
        } else if let removeButtonPressed = model.onRemoveButtonPressed { // for SwiftUI
            removeButtonPressed(self)
        }
    }
    
    private func getBackgroundColor() -> some View {
        return LinearGradient(
            colors: model.isSelected ? [Color(model.selectedBackgroundColor)] : model.tagBackgroundColor.map { Color($0) },
            startPoint: .bottomLeading,
            endPoint: .topTrailing)
    }
    
    private func getStrokeColor() -> some ShapeStyle {
        return LinearGradient(
            colors: model.isSelected ? [Color(model.selectedBorderColor)] : model.borderColor.map { Color($0) },
            startPoint: .bottomLeading,
            endPoint: .topTrailing)
    }
}

extension TagSubView: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model.id)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.model.id == rhs.model.id
    }
}

struct NoTapAnimationStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .onTapGesture(perform: configuration.trigger)
    }
}
