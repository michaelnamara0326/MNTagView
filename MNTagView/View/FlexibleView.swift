//
//  FlexibleView.swift
//
//
//  Created by Michael Namara on 2024/3/6.
//

import SwiftUI

protocol FlexibleViewDelegate {
    func totalOfRow(row: Int)
}

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let axis: TagListScrollAxis
    @Binding var totalOfRow: Int
    let content: (Data.Element) -> Content
    @State private var availableWidth: CGFloat = 10
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    availableWidth = size.width
                }
            
            _FlexibleView(
                availableWidth: availableWidth,
                data: data,
                spacing: spacing,
                alignment: alignment,
                axis: axis,
                content: content,
                totalOfRow: $totalOfRow
            )
        }
    }
}

struct _FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let axis: TagListScrollAxis
    let content: (Data.Element) -> Content
    @Binding var totalOfRow: Int
    @State var elementsSize: [Data.Element: CGSize] = [:]
    
    var body : some View {
        switch axis {
        case .horizontal:
            HStack(alignment: .center) {
                createRow()
            }
            
        case .vertical, .none:
            VStack(alignment: alignment, spacing: spacing) {
                createRow()
            }
        }
    }
    
    private func createRow() -> some View {
        ForEach(computeRows(), id: \.self) { rowElements in
            HStack(spacing: spacing) {
                ForEach(rowElements, id: \.self) { element in
                    content(element)
                        .fixedSize()
                        .readSize { size in
                            elementsSize[element] = size
                        }
                }
            }
        }
    }
    
    private func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth
        
        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]
            if remainingWidth - (elementSize.width + spacing) >= 0 {
                rows[currentRow].append(element)
            } else {
                currentRow += 1
                rows.append([element])
                remainingWidth = availableWidth
            }
            remainingWidth -= (elementSize.width + spacing)
        }
        totalOfRow = data.isEmpty ? 0 : rows.count
        return rows
    }
}
