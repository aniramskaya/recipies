//
//  CookingTime.swift
//  RecipieList
//
//  Created by Марина Чемезова on 23.12.2025.
//

import SwiftUI

struct Rating: View {
    let value: Float
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "star")
                .foregroundStyle(Color("icon.primary"))
                .font(.system(size: 18, weight: .semibold))
            Text(value, format: .number.precision(.fractionLength(1)))
                .font(.system(size: 18, weight: .bold))
                .monospacedDigit()
             
        }
    }
}

#Preview {
    Rating(value: 4.7)
}
