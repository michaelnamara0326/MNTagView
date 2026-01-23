# MNTagView

[English](README.md) | [繁體中文](README_TW.md)

**MNTagView** is a modern Tag View framework built on the power of SwiftUI, designed specifically for **iOS 17+**. It leverages the latest Layout protocol to deliver high-performance flow layouts while providing a highly unified and easy-to-use API for both SwiftUI and UIKit.

## 💡 Design Philosophy

You might wonder: *"Why use this package instead of just using a custom `TagLayout` in SwiftUI?"*

While creating a simple flow layout in SwiftUI is possible, `MNTagView` is designed as a complete **solution** rather than just a layout tool. It saves you time by handling common but tedious tasks out of the box:

1.  **Drop-in Ready**: No need to build your own tag views. It comes with built-in styling for borders, backgrounds, and corner radiuses.
2.  **State Management**: It handles selection states and "Edit Mode" (remove buttons) logic for you.
3.  **Unified API**: The most significant advantage is for teams maintaining hybrid codebases. It provides a consistent configuration experience across both **SwiftUI** and **UIKit**, allowing you to share the same design logic without rewriting view controllers.

If you need a quick, reliable, and cross-platform tag list without reinventing the wheel, `MNTagView` is for you.

## ✨ Features

*   **⚡️ Built for iOS 17+**: Utilizes SwiftUI's modern `Layout` protocol for superior performance and stable flow layouts.
*   **📱 Seamless Cross-Platform Support**:
    *   **SwiftUI**: Supports native `Binding` for reactive data flow, adhering to the "Single Source of Truth" principle.
    *   **UIKit**: Provides a complete property facade, making it feel just like a native `UIView`.
*   **🎨 Highly Customizable**:
    *   Customizable corner radius, borders, font size, and font name.
    *   Supports single background colors and text colors.
    *   Flexible padding configuration using `MNEdgeInsets` for cross-platform compatibility.
*   **🛠 Flexible Layout**:
    *   Supports **Vertical**, **Horizontal** scrolling, or **None** (auto-expanding).
    *   Supports **Leading**, **Center**, and **Trailing** alignment.
*   **👆 Interactive**: Built-in support for tap selection and remove buttons.
    *   **Business Logic**: When the remove button is enabled (Edit Mode), the tap selection is automatically disabled to allow users to focus on editing.
*   **💾 Custom Data Support**: Each tag can carry extra information (Metadata) using the `metaData` property with type-safe generic accessors.

## 📦 Installation

### Swift Package Manager (SPM)

In Xcode, select `File` > `Add Packages...` and enter the following URL:

```
https://github.com/michaelnamara0326/MNTagView.git
```

> **Note**: This package requires **iOS 17.0** or later.

## 🚀 Usage

### SwiftUI

MNTagView offers a SwiftUI-idiomatic API with `Binding` support for automatic data synchronization.

```swift
import SwiftUI
import MNTagView

struct ContentView: View {
    @State private var tags = ["SwiftUI", "iOS", "Apple", "WWDC"]
    
    var body: some View {
        TagListViewSwiftUI(tags: $tags)
            // 1. Layout Configuration
            .scrollAxis(.vertical)
            .alignment(.leading)
            .spacing(10)
            
            // 2. Styling
            .tagCornerRadius(12)
            .tagBackgroundColor(.blue)
            .tagTextColor(.white)
            .viewPadding(MNEdgeInsets(16)) // Unified MNEdgeInsets
            
            // 3. Interactions
            .onTagPressed { tag in
                // This won't trigger if .tagRemoveButtonEnable(true)
                print("Pressed: \(tag.model.title)")
                tag.model.isSelected.toggle()
            }
            .onRemoveTag { tag in
                // Data is automatically removed from the 'tags' array when using Binding
                print("Removed: \(tag.model.title)")
            }
    }
}
```

### UIKit

In UIKit, you no longer need to deal with complex ViewModels. We provide a direct property interface.

```swift
import UIKit
import MNTagView

class ViewController: UIViewController {
    
    let tagView = TagListViewUIKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tagView)
        tagView.frame = CGRect(x: 0, y: 100, width: 300, height: 200)
        
        // 1. Set Data
        tagView.tags = ["UIKit", "Interface", "Legacy", "Modern"]
        
        // 2. Set Delegate
        tagView.delegate = self
        
        // 3. Styling (Direct properties)
        tagView.scrollAxis = .vertical
        tagView.alignment = .leading
        tagView.spacing = 8
        tagView.tagBackgroundColor = .systemBlue
        tagView.textColor = .white
        tagView.cornerRadius = 8
        
        // Cross-platform padding
        tagView.tagPadding = MNEdgeInsets(horizontal: 12, vertical: 6)
        
        // Enable Remove Button (tagPressed delegate will be disabled)
        tagView.isRemoveButtonEnabled = true
    }
}

extension ViewController: TagViewDelegate {
    func tagPressed(_ tag: TagSubView) {
        print("Tag selected: \(tag.model.title)")
        tag.model.isSelected.toggle()
    }
    
    func removeButtonPressed(_ tag: TagSubView) {
        print("Remove requested for: \(tag.model.title)")
        // In UIKit, you must manually call remove to update the UI if managing data manually
        tagView.removeTagView(tag: tag) 
    }
}
```

## ⚙️ Advanced Configuration (MNTagConfig)

To manage styles centrally, you can use `MNTagConfig` to apply multiple settings at once:

```swift
var config = MNTagConfig()
config.cornerRadius = 20
config.textSize = 14
config.textColor = .white
config.tagBackgroundColor = .systemPurple
config.tagPadding = MNEdgeInsets(10) // Unified padding

// SwiftUI
TagListViewSwiftUI(tags: $tags)
    .setConfig(config)

// UIKit
tagView.setConfig(config)
```

## 📐 MNEdgeInsets

To unify padding configuration across both platforms, we introduced `MNEdgeInsets`. It converts seamlessly to SwiftUI's `EdgeInsets` or UIKit's `UIEdgeInsets`.

```swift
// Uniform
let insets = MNEdgeInsets(10)

// Horizontal / Vertical
let insets = MNEdgeInsets(horizontal: 16, vertical: 8)

// Custom
let insets = MNEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
```

## 💾 Custom Data (Metadata)

Each tag can carry custom metadata. You can retrieve it in a type-safe way using the `.data<T>()` method:

```swift
// 1. Set custom data (can be any type)
let tag = TagSubView(title: "Apple", metaData: Product(id: 99, price: 50))

// 2. Retrieve data type-safely
if let product: Product = tag.model.data() {
    print("Product ID: \(product.id)")
}
```

## 📱 Demo App

This project includes a comprehensive Demo App (in the `TagViewDemo` folder) showcasing:
*   Complete implementation examples for both SwiftUI and UIKit.
*   **Interactive Control Panel**: Real-time adjustment of alignment, spacing, corner radius, colors, etc.
*   **Pinned Preview**: See changes instantly as you tweak settings.

## 📄 License

MNTagView is released under the MIT license. See LICENSE for details.