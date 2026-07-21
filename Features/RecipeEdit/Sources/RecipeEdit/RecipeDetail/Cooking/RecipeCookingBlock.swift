//
//  RecipeCookingBlock.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.07.2026.
//

import SwiftUI
import RecipeUIKit

struct RecipeCookingBlock: View {
    let steps: [RecipeStepViewModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(.cookingBlockHeader)
                .font(.title2)
                .bold()
                .accessibilityAddTraits([.isHeader])
                .accessibilityHeading(.h1)

            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                RecipeStepView(model: step, stepNumber: UInt(index + 1))
            }
        }
        .padding(20)
        .accessibilityIdentifier(RecipeCookingBlockA11y.component)
    }
}

enum RecipeCookingBlockA11y {
    static let component = "RecipeCookingBlock"
}

#Preview {
    RecipeCookingBlock(steps: [
        .init(
            id: .init(),
            title: "Маринование",
            imageSource: .uiImage(RecipeUIKitAssets.image(named: "kiev")!),
            text: "Нарежьте куриные бёдра на кусочки 4–5 см. Смешайте с йогуртом, чесноком, имбирём и специями маринада. Накройте и оставьте в холодильнике минимум на 1 час."
        ),
        .init(id: .init(), title: "Обжарка", imageSource: nil, text: "Разогрейте сковороду-гриль на сильном огне. Обжаривайте курицу порциями по 3–4 мин с каждой стороны до золотистых подпалин. Отложите в сторону.")
    ])
}
