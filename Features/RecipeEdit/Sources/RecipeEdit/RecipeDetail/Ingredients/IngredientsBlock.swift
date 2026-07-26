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
    let recipeTitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: RecipeStyles.Spacing.small) {
            Text(.ingredientsTitle)
                .font(.title2.bold())
                .accessibilityIdentifier(A11y.title)
                .accessibilityAddTraits([.isHeader])
                .accessibilityHeading(.h1)

            IngredientListView(model: model)
                .accessibilityIdentifier(A11y.list)

            ShareLink(item: shoppingListText) {
                Label("Список покупок (\(model.uncheckedCount))", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.borderless)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .tint(RecipeUIKitAssets.Color.iconPrimary)
            .disabled(model.uncheckedCount == 0)
            .accessibilityIdentifier(A11y.share)
        }
        .padding(RecipeStyles.Padding.default)
    }

    private var shoppingListText: String {
        let date = Date().formatted(.dateTime.day().month().locale(Locale(identifier: "ru_RU")))
        let header = "Купить для \(recipeTitle) · \(date)"
        let lines = model.items
            .filter { !$0.isOn }
            .map { "• \($0.name)" }
            .joined(separator: "\n")
        return "\(header)\n\n\(lines)"
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
    
    IngredientsBlock(model: model, recipeTitle: "Баттер Чикен")
}
