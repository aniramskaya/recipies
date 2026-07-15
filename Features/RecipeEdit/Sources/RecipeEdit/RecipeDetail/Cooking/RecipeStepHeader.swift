//
//  RecipeStepHeader.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import SwiftUI

struct RecipeStepHeader: View {
    let step: UInt
    let title: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(Color.orange)
                .frame(width: 24, height: 24)
                .overlay {
                    Text("\(step)")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .accessibilityIdentifier(A11y.step)
                }
            
            Text(title)
                .font(.headline)
                .padding([.top], 2)
                .accessibilityIdentifier(A11y.title)
        }
        .accessibilityLabel(.cookingStepHeader(step: step, name: title))
        .accessibilityIdentifier(A11y.component)
    }
}

private typealias A11y = RecipeStepHeaderA11y

enum RecipeStepHeaderA11y {
    static let component = "RecipeStepHeader"
    static let step = "RecipeStepHeaderStepNumber"
    static let title = "RecipeStepHeaderTitle"
}

#Preview {
    RecipeStepHeader(step: 1, title: "Маринование")
}
