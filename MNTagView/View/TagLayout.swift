//
//  TagLayout.swift
//  MNTagView
//
//  Created by Michael Namara on 2026/1/22.
//

import SwiftUI

@available(iOS 16.0, *)
struct TagLayout: Layout {
    var alignment: HorizontalAlignment = .leading
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews, isLayout: false)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews, isLayout: true)
        
        for (index, point) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y), proposal: ProposedViewSize.unspecified)
        }
    }
    
    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews, isLayout: Bool) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var viewPositions: [CGPoint] = []
        
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        var currentRowCount = 0
        
        // Track the indices of views in the current row to adjust their X position for alignment later
        var currentRowIndices: [Int] = []
        
        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(.unspecified)
            
            // Check if we need to break to a new line
            if currentX + size.width > maxWidth && currentRowCount > 0 {
                // Adjust alignment for the completed row
                if isLayout {
                    adjustAlignment(for: currentRowIndices, positions: &viewPositions, rowWidth: currentX - spacing, maxWidth: maxWidth)
                }
                
                // Reset for new row
                currentX = 0
                currentY += currentRowHeight + spacing
                currentRowHeight = 0
                currentRowCount = 0
                currentRowIndices = []
            }
            
            // Add view to current row
            if isLayout {
                viewPositions.append(CGPoint(x: currentX, y: currentY))
            }
            
            currentRowIndices.append(index)
            
            currentX += size.width + spacing
            currentRowHeight = max(currentRowHeight, size.height)
            currentRowCount += 1
        }
        
        // Adjust alignment for the last row
        if isLayout {
            adjustAlignment(for: currentRowIndices, positions: &viewPositions, rowWidth: currentX - spacing, maxWidth: maxWidth)
        }
        
        let finalWidth = maxWidth == .infinity ? currentX : maxWidth
        let finalHeight = currentY + currentRowHeight
        
        return (CGSize(width: finalWidth, height: finalHeight), viewPositions)
    }
    
    private func adjustAlignment(for indices: [Int], positions: inout [CGPoint], rowWidth: CGFloat, maxWidth: CGFloat) {
        guard !indices.isEmpty else { return }
        
        let diff = maxWidth - rowWidth
        var offsetX: CGFloat = 0
        
        switch alignment {
        case .center:
            offsetX = diff / 2
        case .trailing:
            offsetX = diff
        default: // .leading
            offsetX = 0
        }
        
        // If maxWidth is infinity (unbounded), alignment doesn't really shift things relative to a container,
        // but typically flow layout is used within a bounded width.
        if maxWidth != .infinity && offsetX > 0 {
            for index in indices {
                positions[index].x += offsetX
            }
        }
    }
}
