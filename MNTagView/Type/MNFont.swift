//
//  MNFont.swift
//  MNTagView
//
//  Created by Michael Namara on 2026/1/22.
//

import SwiftUI
import UIKit

/// A unified font wrapper for MNTagView to support both SwiftUI Font and UIKit UIFont.
/// Currently stores font as (name, size) to bridge between platforms easily.
public struct MNFont: Equatable, Hashable {
    public var name: String
    public var size: CGFloat
    
    /// Use system font
    public static func system(size: CGFloat) -> MNFont {
        return MNFont(name: "", size: size)
    }
    
    /// Use custom font
    public init(name: String, size: CGFloat) {
        self.name = name
        self.size = size
    }
    
    // MARK: - Internal Conversion
    
    internal var uiFont: UIFont {
        if name.isEmpty {
            return UIFont.systemFont(ofSize: size)
        } else {
            return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
    
    internal var swiftUIFont: Font {
        if name.isEmpty {
            return Font.system(size: size)
        } else {
            return Font.custom(name, size: size)
        }
    }
}

// MARK: - Extensions for easy init

extension MNFont {
    public init(_ uiFont: UIFont) {
        self.name = uiFont.fontName
        self.size = uiFont.pointSize
    }
    
    // Note: SwiftUI Font doesn't easily expose name/size properties, 
    // so we don't provide init(_ font: Font) directly as it would require introspection.
    // Instead, the modifiers in SwiftUI view will take name/size or map system fonts manually.
}
