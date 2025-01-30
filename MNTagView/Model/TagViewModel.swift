//
//  TagViewModel.swift
//
//
//  Created by Michael Namara on 2024/4/3.
//

import UIKit
import SwiftUI

@MainActor
public class TagViewModel: ObservableObject {
    let id = UUID()
    weak var delegate: TagViewDelegate?
    public var onTagPressed: ((TagSubView) -> Void)?
    public var onRemoveButtonPressed: ((TagSubView) -> Void)?
    public let customData: Any? // if tag need store any data can use this param
    @Published public var title: String
    @Published public var isSelected: Bool = false
    @Published public var cornerRadius: CGFloat = 0
    @Published public var textColor: UIColor = .red
    @Published public var borderWidth: CGFloat = 0
    @Published public var borderColor: [UIColor] = []
    @Published public var tagPadding: EdgeInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
    @Published public var tagBackgroundColor: [UIColor] = []
    @Published public var selectedTextColor: UIColor = .white
    @Published public var selectedBackgroundColor: UIColor = .blue
    @Published public var selectedBorderColor: UIColor = .clear
    @Published public var removeButtonEnable: Bool = false
    @Published public var removeButtonIconSize: CGSize = CGSize(width: 10, height: 10)
    @Published public var removeButtonIconColor: UIColor = .red
    @Published public var textFontName: String = ""
    @Published public var textSize: CGFloat = 12
    @Published public var customImage: UIImage? = nil
    @Published public var customImageSize: CGSize = .zero
    
    public init(title: String, isSelected: Bool = false, customData: Any? = nil) {
        self.title = title
        self.isSelected = isSelected
        self.customData = customData
    }
}
