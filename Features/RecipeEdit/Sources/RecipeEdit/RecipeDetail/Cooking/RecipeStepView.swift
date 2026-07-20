//
//  RecipeStep.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import SwiftUI
import RecipeUIKit

struct RecipeStepView: View {
    let model: RecipeStepViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RecipeStepHeader(step: model.step, title: model.title)
            
            if let imageSource = model.imageSource {
                RecipeImageView(source: imageSource)
                    .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .accessibilityIdentifier(A11y.image)
            }
            
            Text(model.text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityIdentifier(A11y.text)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(RecipeUIKitAssets.Color.cookingStepBackground)
        .cornerRadius(12)
        .accessibilityIdentifier(A11y.component)
    }
}

private typealias A11y = RecipeStepViewA11y

enum RecipeStepViewA11y {
    static let component = "RecipeStepView"
    static let image = "RecipeStepImage"
    static let text = "RecipeStepText"
}

#Preview {
    RecipeStepView(model:
        .init(
            step: 1,
            title: "Маринование",
            imageSource: .uiImage(RecipeUIKitAssets.image(named: "kiev")!),
            text: "Нарежьте куриные бёдра на кусочки 4–5 см. Смешайте с йогуртом, чесноком, имбирём и специями маринада. Накройте и оставьте в холодильнике минимум на 1 час."
        )
    )
    .padding(20)
    
    RecipeStepView(model:
        .init(
            step: 1,
            title: "Маринование",
            imageSource: nil,
            text: "Нарежьте куриные бёдра на кусочки 4–5 см. Смешайте с йогуртом, чесноком, имбирём и специями маринада. Накройте и оставьте в холодильнике минимум на 1 час."
        )
    )
    .padding(20)
}
