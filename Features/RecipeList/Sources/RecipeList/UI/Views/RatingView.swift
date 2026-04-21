//
//  CookingTime.swift
//  RecipeList
//
//  Created by Марина Чемезова on 23.12.2025.
//

import SwiftUI
import RecipeUIKit

struct RatingView: View {
    let value: Float
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "star")
                .foregroundStyle(RecipeListUIAssets.Color.iconPrimary)
                .font(.system(size: 18, weight: .semibold))
            Text(value, format: .number.precision(.fractionLength(1)))
                .font(.system(size: 18, weight: .bold))
                .monospacedDigit()
             
        }
    }
}

#Preview {
    RatingView(value: 4.7)
}
