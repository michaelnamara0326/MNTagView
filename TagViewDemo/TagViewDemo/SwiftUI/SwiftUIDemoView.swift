//
//  SwiftUIDemoView.swift
//  TagViewDemo
//
//  Created by Michael Namara on 2024/4/1.
//

import SwiftUI
import MNTagView

struct SwiftUIDemoView: View {
    var body: some View {
        TagListViewSwiftUI(titles: ["台北市士林區", "台北市一二區", "台北市三四區", "台北市五六區"])
            .options(scrollAxis: .horizontal,
                     textFontName: "PingFangTC-Regular",
                     textSize: 14,
                     textColor: Color(.blue),
                     tagBackgroundColor: .clear,
                     selectedBackgroundColor: Color(.yellow),
                     cornerRadius: 40,
                     tagPadding: EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12),
                     borderWidth: 1,
                     bordercolor: Color(.blue),
                     showScrollIndicator: false)
            .pressedTag { tagView in
                print("press tag: \(tagView.model.title)")
                tagView.model.isSelected.toggle()
            }
            .padding()
            .background(Color.gray)
    }
}

#Preview {
    SwiftUIDemoView()
}
