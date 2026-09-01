//
//  IngredientsEditBlock.swift
//  Recipe
//
//  Created by Марина Чемезова on 07.08.2026.
//

import SwiftUI

struct IngredientsEditBlock: View {
    @Binding var items: [IngredientDraftModel]
    @State var lastAddedIngredientId: UUID?

    var body: some View {
        VStack(alignment: .leading, spacing: RecipeStyles.Spacing.small) {
            Text(.ingredientsTitle)
                .font(.title2.bold())
                .accessibilityIdentifier(A11y.title)
                .accessibilityAddTraits([.isHeader])
                .accessibilityHeading(.h1)

            IngredientsEditView(ingredients: $items, lastAddedIngredientId: lastAddedIngredientId)
                .accessibilityIdentifier(A11y.list)

            HStack {
                Spacer()
                Button(action: addNewItem) {
                    Image(systemName: "plus.circle")
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.orange)
                    Text(.addIngredient)
                        .font(.headline)
                        .foregroundStyle(Color.orange)
                }
                .accessibilityIdentifier(A11y.addButton)
            }
        }
        .padding(RecipeStyles.Padding.default)
    }
    
    private func addNewItem() {
        let newItemId = UUID()
        items.append(.init(id: newItemId, name: ""))
        Task { @MainActor in
            lastAddedIngredientId = newItemId
        }
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
