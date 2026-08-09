//
//  IngredientsEditBlock.swift
//  Recipe
//
//  Created by Марина Чемезова on 07.08.2026.
//

import SwiftUI

struct IngredientsEditBlock: View {
    @Binding var items: [IngredientDraftModel]

    var body: some View {
        VStack(alignment: .leading, spacing: RecipeStyles.Spacing.small) {
            Text(.ingredientsTitle)
                .font(.title2.bold())
                .accessibilityIdentifier(A11y.title)
                .accessibilityAddTraits([.isHeader])
                .accessibilityHeading(.h1)

            IngredientsEditView(ingredients: $items)
                .accessibilityIdentifier(A11y.list)

            HStack {
                Spacer()
                Button(action: addNewItem) {
                    Text("+ Добавить ингредиент")
                        .font(.headline)
                        .foregroundStyle(Color.orange)
                }
                .accessibilityIdentifier(A11y.addButton)
            }
        }
        .padding(RecipeStyles.Padding.default)
    }
    
    private func addNewItem() {
        items.append(.init(id: .init(), name: ""))
    }
}

private typealias A11y = IngredientsEditBlockA11y

enum IngredientsEditBlockA11y {
    static let title = "IngredientsEditTitle"
    static let list = "IngredientsEditList"
    static let addButton = "IngredientsEditAdd"
}

#Preview {
    @Previewable @State var items: [IngredientDraftModel] = [
        .init(id: UUID(), name: "400 мл воды"),
        .init(id: UUID(), name: "1 пакетик чая"),
    ]

    
    IngredientsEditBlock(items: $items)
}
