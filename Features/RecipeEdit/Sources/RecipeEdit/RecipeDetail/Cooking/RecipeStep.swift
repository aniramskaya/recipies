//
//  RecipeStep.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import SwiftUI
import RecipeUIKit

struct RecipeStepView: View {
    let step: UInt
    let title: String
    let imageUrl: URL?
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RecipeStepHeader(step: step, title: title)
            
            Text(text)
        }
        .padding(20)
        .background(RecipeUIKitAssets.Color.cookingStepBackground)
        .cornerRadius(12)
    }
}

#Preview {
    RecipeStepView(
        step: 1,
        title: "Маринование",
        imageUrl: nil,
        text: "Нарежьте куриные бёдра на кусочки 4–5 см. Смешайте с йогуртом, чесноком, имбирём и специями маринада. Накройте и оставьте в холодильнике минимум на 1 час.")
    .padding(20)
}
