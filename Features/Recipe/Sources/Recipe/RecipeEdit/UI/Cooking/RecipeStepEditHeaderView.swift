//
//  RecipeStepHeaderEditView.swift
//  Recipe
//
//  Created by Марина Чемезова on 04.09.2026.
//
import SwiftUI
import RecipeUIKit

struct RecipeStepEditHeaderView: View {
    let step: UInt
    @Binding var title: String
    
    var body: some View {
        HStack(alignment: .center, spacing: RecipeStyles.Spacing.small) {
            Circle()
                .fill(Color.orange)
                .frame(width: 24, height: 24)
                .overlay {
                    Text("\(step)")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .accessibilityIdentifier(A11y.step)
                        .accessibilityHidden(true)
                }
            
            TextField(String(localized: .textBlockTitle), text: $title)
                .font(.headline).bold()
                .accessibilityLabel(.cookingStepHeader(step: step, name: ""))
                .accessibilityIdentifier(A11y.title)
                .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 10))
                .background(
                    RoundedRectangle(cornerRadius: RecipeStyles.Radius.small)
                        .fill(RecipeUIKitAssets.Color.fieldBackground)
                )
        }
        .accessibilityIdentifier(A11y.component)
    }
}

private typealias A11y = RecipeStepEditHeaderA11y

enum RecipeStepEditHeaderA11y {
    static let component = "RecipeStepEditHeader"
    static let step = "RecipeStepEditHeaderStepNumber"
    static let title = "RecipeStepEditHeaderTitle"
}

#Preview {
    @Previewable @State var title: String = ""

    RecipeStepEditHeaderView(step: 1, title: $title)
}
