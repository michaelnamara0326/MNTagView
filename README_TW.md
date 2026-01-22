# MNTagView

[English](README.md) | [繁體中文](README_TW.md)

**MNTagView** 是一個基於 SwiftUI 強大功能構建的現代化標籤列表 (Tag View) 套件，專為 iOS 17+ 設計。它利用了最新的 Layout 協議來提供高效能的自動換行佈局，同時為 SwiftUI 和 UIKit 提供了高度統一且易於使用的 API。

## ✨ 特色

*   **⚡️ 專為 iOS 17+ 打造**: 採用 SwiftUI 最新的 `Layout` 協議，效能優異且佈局穩定。
*   **📱 雙平台完美支援**:
    *   **SwiftUI**: 支援原生 `Binding` 資料綁定，符合 "Single Source of Truth" 原則。
    *   **UIKit**: 提供完整的屬性封裝 (Facade)，使用起來就像原生的 `UIView`。
*   **🎨 高度可客製化**:
    *   支援自定義圓角、邊框、文字大小、字型。
    *   支援單色背景、文字顏色。
    *   提供靈活的內距設定 (`MNEdgeInsets`)，跨平台無縫轉換。
*   **🛠 靈活的佈局**:
    *   支援 **垂直 (Vertical)**、**水平 (Horizontal)** 滾動或 **不滾動 (None)** 自動延展。
    *   支援 **靠左 (Leading)**、**置中 (Center)**、**靠右 (Trailing)** 對齊。
*   **👆 互動功能**: 內建點擊選取與刪除按鈕功能。
    *   **商務邏輯**: 當開啟刪除按鈕（編輯模式）時，點擊選取功能會自動停用，確保使用者專注於編輯。
*   **💾 自定義資料支援**: 每個標籤都可以透過 `metaData` 屬性攜帶額外資訊（Metadata），並提供型別安全的泛型存取方法。

## 📦 安裝

### Swift Package Manager (SPM)

在 Xcode 中，選擇 `File` > `Add Packages...` 並輸入以下 URL：

```
https://github.com/michaelnamara0326/MNTagView.git
```

> **注意**: 本套件最低支援 **iOS 17.0**。

## 🚀 使用方法

### SwiftUI

MNTagView 提供了符合 SwiftUI 習慣的 API，支援 `Binding` 來自動同步資料。

```swift
import SwiftUI
import MNTagView

struct ContentView: View {
    @State private var tags = ["SwiftUI", "iOS", "Apple", "WWDC"]
    
    var body: some View {
        TagListViewSwiftUI(tags: $tags)
            // 1. 佈局設定
            .scrollAxis(.vertical)
            .alignment(.leading)
            .spacing(10)
            
            // 2. 樣式設定
            .tagCornerRadius(12)
            .tagBackgroundColor(.blue)
            .tagTextColor(.white)
            .viewPadding(MNEdgeInsets(16)) // 使用統一的 MNEdgeInsets
            
            // 3. 互動事件
            .onTagPressed { tag in
                // 當 .tagRemoveButtonEnable(true) 時，此處不會觸發
                print("點擊了: \(tag.model.title)")
                tag.model.isSelected.toggle()
            }
            .onRemoveTag { tag in
                // 使用 Binding 初始化時，資料會自動從 tags 陣列移除
                print("移為了: \(tag.model.title)")
            }
    }
}
```

### UIKit

在 UIKit 中，你不再需要處理複雜的 ViewModel，我們提供了直觀的屬性介面。

```swift
import UIKit
import MNTagView

class ViewController: UIViewController {
    
    let tagView = TagListViewUIKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tagView)
        tagView.frame = CGRect(x: 0, y: 100, width: 300, height: 200)
        
        // 1. 設定資料
        tagView.tags = ["UIKit", "Interface", "Legacy", "Modern"]
        
        // 2. 設定委派 (處理點擊/刪除)
        tagView.delegate = self
        
        // 3. 樣式設定 (直接設定屬性)
        tagView.scrollAxis = .vertical
        tagView.alignment = .leading
        tagView.spacing = 8
        tagView.tagBackgroundColor = .systemBlue
        tagView.textColor = .white
        tagView.cornerRadius = 8
        
        // 跨平台內距設定
        tagView.tagPadding = MNEdgeInsets(horizontal: 12, vertical: 6)
        
        // 啟用刪除按鈕 (此時 tagPressed 委派不會觸發)
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
        // 在 UIKit 中，你需要手動呼叫移除方法來更新 UI
        tagView.removeTagView(tag: tag) 
    }
}
```

## ⚙️ 進階配置 (MNTagConfig)

為了方便統一管理樣式，你可以使用 `MNTagConfig` 物件一次性套用多個設定：

```swift
var config = MNTagConfig()
config.cornerRadius = 20
config.textSize = 14
config.textColor = .white
config.tagBackgroundColor = .systemPurple
config.tagPadding = MNEdgeInsets(10) // 統一內距

// SwiftUI
TagListViewSwiftUI(tags: $tags)
    .setConfig(config)

// UIKit
tagView.setConfig(config)
```

## 📐 MNEdgeInsets

為了在這個雙平台套件中統一內距 (Padding) 的設定，我們引入了 `MNEdgeInsets`。它可以無縫轉換為 SwiftUI 的 `EdgeInsets` 或 UIKit 的 `UIEdgeInsets`。

```swift
// 四邊統一
let insets = MNEdgeInsets(10)

// 水平/垂直
let insets = MNEdgeInsets(horizontal: 16, vertical: 8)

// 自定義四邊
let insets = MNEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
```

## 💾 自定義資料 (Metadata)

每個標籤都可以攜帶自定義的元數據（Metadata），你可以使用 `.data<T>()` 方法以型別安全的方式取回：

```swift
// 1. 設定自定義資料 (可以是任何型別)
let tag = TagSubView(title: "Apple", metaData: Product(id: 99, price: 50))

// 2. 以型別安全的方式取回
if let product: Product = tag.model.data() {
    print("產品 ID: \(product.id)")
}
```

## 📱 Demo 範例

本專案包含一個完整的 Demo App (位於 `TagViewDemo` 資料夾)，展示了：
*   SwiftUI 與 UIKit 的完整實作範例。
*   **互動式控制面板**：可即時調整對齊、間距、圓角、顏色等所有參數。
*   **置頂預覽效果**：在調整參數時可實時預覽標籤變化。

## 📄 License

MNTagView is released under the MIT license. See LICENSE for details.