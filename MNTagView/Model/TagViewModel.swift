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
    
    // Stored as Any to maintain non-generic class hierarchy for UIKit compatibility
    public let customData: Any? 
    
    @Published public var title: String
    @Published public var isSelected: Bool = false
    @Published public var cornerRadius: CGFloat = 0
    @Published public var textColor: UIColor = .red
    @Published public var borderWidth: CGFloat = 0
    @Published public var borderColor: UIColor = .clear
    @Published public var tagPadding: MNEdgeInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
    @Published public var tagBackgroundColor: UIColor = .gray
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
    
    /// Initialize with optional custom data of any type.
    public init<T>(title: String, isSelected: Bool = false, customData: T? = nil) {
        self.title = title
        self.isSelected = isSelected
        self.customData = customData
    }
    
    // Non-generic init for convenience (equivalent to T=Any)
    public init(title: String, isSelected: Bool = false) {
        self.title = title
        self.isSelected = isSelected
        self.customData = nil
    }
    
    /// Type-safe accessor for custom data.
    /// Returns nil if data is nil or cannot be cast to type T.
    public func data<T>() -> T? {
        return customData as? T
    }
}