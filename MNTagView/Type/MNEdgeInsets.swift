//
//  MNEdgeInsets.swift
//  MNTagView
//
//  Created by Michael Namara on 2026/1/22.
//

import SwiftUI
import UIKit

/// A cross-platform edge insets structure to unify SwiftUI.EdgeInsets and UIEdgeInsets.
public struct MNEdgeInsets: Equatable, Hashable {
    public var top: CGFloat
    public var leading: CGFloat
    public var bottom: CGFloat
    public var trailing: CGFloat
    
    public init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }
    
    /// Initialize with a single value for all sides
    public init(_ value: CGFloat) {
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }
    
    /// Initialize with separate horizontal and vertical values
    public init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}

// MARK: - Extensions for Conversion

extension MNEdgeInsets {
    public var swiftUIEdgeInsets: EdgeInsets {
        EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    public var uiEdgeInsets: UIEdgeInsets {
        UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
    }
}

// Allow initialization from platform types
extension MNEdgeInsets {
    public init(_ edgeInsets: EdgeInsets) {
        self.init(top: edgeInsets.top, leading: edgeInsets.leading, bottom: edgeInsets.bottom, trailing: edgeInsets.trailing)
    }
    
    public init(_ uiEdgeInsets: UIEdgeInsets) {
        self.init(top: uiEdgeInsets.top, leading: uiEdgeInsets.left, bottom: uiEdgeInsets.bottom, trailing: uiEdgeInsets.right)
    }
}
