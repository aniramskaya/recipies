//
//  DragHandleView.swift
//  Recipe
//
//  Created by Марина Чемезова on 07.08.2026.
//

import SwiftUI

struct DragHandleView: View {
    var width: CGFloat = 20
    var lineHeight: CGFloat = 2
    var spacing: CGFloat = 3
    var color: Color = .secondary

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<3) { _ in
                Capsule()
                    .fill(color)
                    .frame(width: width, height: lineHeight)
            }
        }
    }
}

#Preview {
    DragHandleView()
}
