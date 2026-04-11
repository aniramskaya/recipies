//
//  RecipeComplexityView.swift
//  RecipeList
//
//  Created by Marina Chemezova on 11.04.2026.
//

import SwiftUI

struct RecipeComplexityView: View {
    let value: Int

    private var clampedValue: Int {
        max(0, min(5, value))
    }

    private let barHeights: [CGFloat] = [4, 8, 14, 18, 22]
    private let activeColor = Color(red: 1.0, green: 149 / 255, blue: 0)
    private let inactiveColor = Color(red: 1.0, green: 149 / 255, blue: 0).opacity(0.4)

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(0..<5, id: \.self) { index in
                Rectangle()
                    .fill(index < clampedValue ? activeColor : inactiveColor)
                    .frame(width: 8, height: barHeights[index])
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        RecipeComplexityView(value: 0)
        RecipeComplexityView(value: 2)
        RecipeComplexityView(value: 5)
        RecipeComplexityView(value: -1)
        RecipeComplexityView(value: 10)
    }
    .padding()
}
