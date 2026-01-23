//
//  MNTagConfig.swift
//  MNTagView
//
//  Created by Michael Namara on 2026/1/22.
//

import SwiftUI
import UIKit

public struct MNTagConfig {
    public var cornerRadius: CGFloat = 0
    public var textColor: UIColor = .white
    public var font: MNFont = .system(size: 12)
    public var tagPadding: MNEdgeInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
    public var tagBackgroundColor: UIColor = .gray
    
    public var selectedTextColor: UIColor = .white
    public var selectedBackgroundColor: UIColor = .blue
    public var selectedBorderColor: UIColor = .clear
    
    public var borderWidth: CGFloat = 0
    public var borderColor: UIColor = .clear
    
    public var removeButtonEnable: Bool = false
    public var removeButtonIconSize: CGSize = CGSize(width: 10, height: 10)
    public var removeButtonIconColor: UIColor = .red
    
    public init() {}
}
