//
//  CookingTime.swift
//  RecipieList
//
//  Created by Марина Чемезова on 23.12.2025.
//

import SwiftUI
import RecipeUIKit

struct CookingTimeView: View {
    let minutes: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "hourglass")
                .foregroundStyle(Color("icon.primary", bundle: RecipeListUIAssets.bundle))
                .font(.system(size: 18, weight: .semibold))
            (Text("\(minutes)")
                .font(.system(size: 18, weight: .bold))
                .monospacedDigit()
             + Text(" min")
                .font(.system(size: 18, weight: .regular)))
        }
    }
}

#Preview {
    CookingTimeView(minutes: 35)
}
