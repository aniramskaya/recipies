//
//  CookingTime.swift
//  RecipeList
//
//  Created by Марина Чемезова on 23.12.2025.
//

import SwiftUI
import RecipeUIKit

struct CookingTimeView: View {
    let minutes: Int
    
    var body: some View {
        let value = Text("\(minutes)")
            .font(.system(size: 18, weight: .bold))
            .monospacedDigit()
        
        let unit = Text("min")
            .font(.system(size: 18, weight: .regular))
        
        HStack(spacing: 8) {
            Image(systemName: "hourglass")
                .foregroundStyle(Color("icon.primary", bundle: RecipeListUIAssets.bundle))
                .font(.system(size: 18, weight: .semibold))
            Text("\(value) \(unit)")
        }
    }
}

#Preview {
    CookingTimeView(minutes: 35)
}
