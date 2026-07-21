//
//  IngredientsBlock.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 04.07.2026.
//

import SwiftUI
import RecipeUIKit

struct IngredientsBlock: View {
    @ObservedObject var model: IngredientListModel
    let onShare: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(.ingredientsTitle)
                .font(.title2.bold())
                .accessibilityIdentifier(A11y.title)
                .accessibilityAddTraits([.isHeader])
                .accessibilityHeading(.h1)

            IngredientListView(model: model)
                .accessibilityIdentifier(A11y.list)

            Button {
                onShare()
            }
            label:{
                Image(systemName: "square.and.arrow.up")
                Text("Список покупок (\(model.uncheckedCount))")
            }
            .buttonStyle(.borderless)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .tint(RecipeUIKitAssets.Color.iconPrimary)
            .disabled(model.uncheckedCount == 0)
            .accessibilityIdentifier(A11y.share)
        }
        .padding(20)
    }
}

private typealias A11y = IngredientsBlockA11y

enum IngredientsBlockA11y {
    static let title = "IngredientsTitle"
    static let list = "IngredientsList"
    static let share = "IngredientsShare"
}

#Preview {
    let model = IngredientListModel(items: [
        .init(isOn: false, name: "700 г куриных бёдер без кожи и без костей и тут длинный текст"),
        .init(isOn: false, name: "120 г натурального йогурта"),
        .init(isOn: false, name: "2 зубчика чеснока"),
        .init(isOn: false, name: "1 ч.л. тёртого имбиря"),
        .init(isOn: false, name: "1 ч.л. гарам масала"),
        .init(isOn: false, name: "1 ч.л. куркумы"),
        .init(isOn: false, name: "1 ч.л. паприки"),
    ])
    
    IngredientsBlock(model: model) {
        print("Share pressed")
    }
}
