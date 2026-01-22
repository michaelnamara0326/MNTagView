//
//  SwiftUIDemoView.swift
//  TagViewDemo
//
//  Created by Michael Namara on 2024/4/1.
//

import SwiftUI
import MNTagView

struct SwiftUIDemoView: View {
    // Data
    @State private var tags: [String] = ["SwiftUI", "UIKit", "Layout", "Flexible", "Coding", "Apple"]
    
    // Layout Controls
    @State private var scrollAxis: TagListScrollAxis = .vertical
    @State private var alignmentOption: AlignmentOption = .leading
    @State private var spacing: CGFloat = 8
    @State private var viewPadding: CGFloat = 10
    
    // Tag Style Controls
    @State private var tagCornerRadius: CGFloat = 12
    @State private var tagTextSize: CGFloat = 14
    @State private var tagPaddingHorizontal: CGFloat = 12
    @State private var tagPaddingVertical: CGFloat = 8
    @State private var tagBackgroundColor: Color = .blue
    @State private var tagTextColor: Color = .white
    
    // Border Controls
    @State private var borderWidth: CGFloat = 0
    @State private var borderColor: Color = .white
    
    // Selection Controls
    @State private var selectedColor: Color = .orange
    @State private var selectedTextColor: Color = .white
    @State private var selectedBorderColor: Color = .clear
    
    // Remove Button Controls
    @State private var isRemoveEnabled: Bool = false
    @State private var removeIconColor: Color = .red
    @State private var removeIconSize: CGFloat = 10
    
    // Section Expand States
    @State private var isLayoutExpanded: Bool = true
    @State private var isAppearanceExpanded: Bool = false
    @State private var isBorderExpanded: Bool = false
    @State private var isSelectionExpanded: Bool = false
    @State private var isRemoveExpanded: Bool = false
    @State private var isDataExpanded: Bool = false
    
    // Wrapper enum to make HorizontalAlignment Hashable/Selectable
    enum AlignmentOption: String, CaseIterable, Identifiable {
        case leading = "Leading"
        case center = "Center"
        case trailing = "Trailing"
        
        var id: String { rawValue }
        
        var value: HorizontalAlignment {
            switch self {
            case .leading: return .leading
            case .center: return .center
            case .trailing: return .trailing
            }
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
                
                // MARK: - Pinned Preview Section
                Section {
                    // Empty content for section, header acts as the pinned view
                } header: {
                    VStack(alignment: .leading) {
                        Text("Interactive Preview")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        TagListViewSwiftUI(tags: $tags)
                            .scrollAxis(scrollAxis)
                            .alignment(alignmentOption.value)
                            .spacing(spacing)
                            .viewPadding(MNEdgeInsets(top: viewPadding, leading: viewPadding, bottom: viewPadding, trailing: viewPadding))
                            // Unified Config
                            .setConfig(MNTagConfig()
                                .updated {
                                    $0.cornerRadius = tagCornerRadius
                                    $0.tagBackgroundColor = [UIColor(tagBackgroundColor)]
                                    $0.textColor = UIColor(tagTextColor)
                                    $0.textSize = tagTextSize
                                    $0.tagPadding = MNEdgeInsets(top: tagPaddingVertical, leading: tagPaddingHorizontal, bottom: tagPaddingVertical, trailing: tagPaddingHorizontal)
                                    
                                    $0.borderWidth = borderWidth
                                    $0.borderColor = [UIColor(borderColor)]
                                    
                                    $0.selectedBackgroundColor = UIColor(selectedColor)
                                    $0.selectedTextColor = UIColor(selectedTextColor)
                                    $0.selectedBorderColor = UIColor(selectedBorderColor)
                                    
                                    $0.removeButtonEnable = isRemoveEnabled
                                    $0.removeButtonIconColor = UIColor(removeIconColor)
                                    $0.removeButtonIconSize = CGSize(width: removeIconSize, height: removeIconSize)
                                }
                            )
                            .onTagPressed { tag in
                                tag.model.isSelected.toggle()
                            }
                            .frame(minHeight: 150)
                            .background(Color(.systemBackground)) // Solid background for pinning
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    .background(Color(.systemGroupedBackground).opacity(0.95)) // Translucent background for header
                    .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
                }
                
                // MARK: - Controls (Scrollable Content)
                VStack(spacing: 0) {
                    // 1. Layout
                    ExpandableControlSection(title: "Layout", isExpanded: $isLayoutExpanded) {
                        VStack(spacing: 12) {
                            Picker("Axis", selection: $scrollAxis) {
                                ForEach(TagListScrollAxis.allCases, id: \.self) { axis in
                                    Text(String(describing: axis).capitalized).tag(axis)
                                }
                            }.pickerStyle(.segmented)
                            
                            Picker("Alignment", selection: $alignmentOption) {
                                ForEach(AlignmentOption.allCases) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }.pickerStyle(.segmented)
                            
                            SliderRow(title: "Spacing", value: $spacing, range: 0...30)
                            SliderRow(title: "View Padding", value: $viewPadding, range: 0...50)
                        }
                    }
                    
                    Divider().padding(.leading)
                    
                    // 2. Tag Appearance
                    ExpandableControlSection(title: "Tag Appearance", isExpanded: $isAppearanceExpanded) {
                        VStack(spacing: 12) {
                            SliderRow(title: "Corner Radius", value: $tagCornerRadius, range: 0...30)
                            SliderRow(title: "Text Size", value: $tagTextSize, range: 8...24)
                            SliderRow(title: "H-Padding", value: $tagPaddingHorizontal, range: 0...30)
                            SliderRow(title: "V-Padding", value: $tagPaddingVertical, range: 0...20)
                            
                            ColorPicker("Background Color", selection: $tagBackgroundColor)
                            ColorPicker("Text Color", selection: $tagTextColor)
                        }
                    }
                    
                    Divider().padding(.leading)
                    
                    // 3. Border
                    ExpandableControlSection(title: "Border", isExpanded: $isBorderExpanded) {
                        VStack(spacing: 12) {
                            SliderRow(title: "Width", value: $borderWidth, range: 0...5)
                            ColorPicker("Color", selection: $borderColor)
                        }
                    }
                    
                    Divider().padding(.leading)
                    
                    // 4. Selection State
                    ExpandableControlSection(title: "Selection State", isExpanded: $isSelectionExpanded) {
                        VStack(spacing: 12) {
                            ColorPicker("Selected BG", selection: $selectedColor)
                            ColorPicker("Selected Text", selection: $selectedTextColor)
                            ColorPicker("Selected Border", selection: $selectedBorderColor)
                        }
                    }
                    
                    Divider().padding(.leading)
                    
                    // 5. Remove Button
                    ExpandableControlSection(title: "Remove Button", isExpanded: $isRemoveExpanded) {
                        VStack(spacing: 12) {
                            Toggle("Enable Remove", isOn: $isRemoveEnabled)
                            if isRemoveEnabled {
                                SliderRow(title: "Icon Size", value: $removeIconSize, range: 5...20)
                                ColorPicker("Icon Color", selection: $removeIconColor)
                            }
                        }
                    }
                    
                    Divider().padding(.leading)
                    
                    // 6. Data Actions
                    ExpandableControlSection(title: "Data", isExpanded: $isDataExpanded) {
                        HStack {
                            Button("Add Tag") {
                                let words = ["New", "Tag", "Cool", "Feature", "Demo"]
                                tags.append("\(words.randomElement()!) \(Int.random(in: 1...99))")
                            }
                            .buttonStyle(.borderedProminent)
                            
                            Button("Clear All") {
                                tags.removeAll()
                            }
                            .buttonStyle(.bordered)
                            .tint(.red)
                        }
                    }
                }
                .padding(.horizontal)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("SwiftUI Config Demo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Helpers

struct ExpandableControlSection<Content: View>: View {
    let title: String
    @Binding var isExpanded: Bool
    let content: () -> Content
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            content()
                .padding(.vertical, 8)
        } label: {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.vertical, 4)
        }
        .padding(.vertical, 8)
    }
}

struct SliderRow: View {
    let title: String
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            Slider(value: $value, in: range)
            Text("\(Int(value))")
                .font(.caption)
                .monospacedDigit()
                .frame(width: 30, alignment: .trailing)
        }
    }
}

// Helper to easily update struct for demo
extension MNTagConfig {
    func updated(_ block: (inout MNTagConfig) -> Void) -> MNTagConfig {
        var copy = self
        block(&copy)
        return copy
    }
}

#Preview {
    NavigationView {
        SwiftUIDemoView()
    }
}
