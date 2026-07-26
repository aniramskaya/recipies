//
//  RecipeComplexityView.swift
//  RecipeList
//
//  Created by Marina Chemezova on 11.04.2026.
//

import SwiftUI

public struct RecipeComplexityView: View {
    let value: Int

    private var clampedValue: Int {
        max(0, min(5, value))
    }

    private let barHeights: [CGFloat] = [4, 8, 14, 18, 22]
    private let activeColor = RecipeUIKitAssets.Color.iconPrimary
    private let inactiveColor = RecipeUIKitAssets.Color.iconPrimary.opacity(0.2)
    
    public init(value: Int) {
        self.value = value
    }

    public var body: some View {
        GeometryReader { geometry in
            let maxBarHeight = barHeights.max() ?? 1
            let spacing = geometry.size.width / 14
            let barWidth = spacing * 2

            HStack(alignment: .bottom, spacing: spacing) {
                ForEach(0..<5, id: \.self) { index in
                    Rectangle()
                        .fill(index < clampedValue ? activeColor : inactiveColor)
                        .frame(
                            width: barWidth,
                            height: barHeights[index] / maxBarHeight * geometry.size.height
                        )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
        }
        .accessibilityElement()
        .accessibilityLabel("Recipe complexity")
        .accessibilityValue(Text("\(clampedValue)"))
    }
}

#Preview {
    VStack(spacing: 20) {
        RecipeComplexityView(value: 0).frame(width: 56, height: 22)
        RecipeComplexityView(value: 2).frame(width: 56, height: 22)
        RecipeComplexityView(value: 5).frame(width: 56, height: 22)
        RecipeComplexityView(value: 2).frame(width: 28, height: 11)
        RecipeComplexityView(value: 5).frame(width: 112, height: 44)
    }
    .padding()
}
