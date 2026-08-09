//
//  IngredientsEditView.swift
//  Recipe
//
//  Created by Марина Чемезова on 07.08.2026.
//

import SwiftUI

struct IngredientsEditView: View {
    @Binding var ingredients: [IngredientDraftModel]
    @State private var draggedItem: IngredientDraftModel?
    
    var body: some View {
        VStack(spacing: RecipeStyles.Spacing.xSmall) {
            ForEach($ingredients, id: \.id) { item in
                IngredientEditView(
                    ingredient: item,
                    draggedItem: $draggedItem
                ) {
                    delete(item: item.wrappedValue)
                }
                .onDrop(
                    of: [.text],
                    delegate: ReorderDropDelegate(
                        item: item.wrappedValue,
                        items: $ingredients,
                        draggedItem: $draggedItem
                    )
                )
            }
        }
    }
    
    private func delete(item: IngredientDraftModel) {
        ingredients.removeAll { $0.id == item.id }
    }
}

private struct ReorderDropDelegate: DropDelegate {
    let item: IngredientDraftModel
    @Binding var items: [IngredientDraftModel]
    @Binding var draggedItem: IngredientDraftModel?
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem,
              item != draggedItem,
              let from = items.firstIndex(of: draggedItem),
              let to = items.firstIndex(of: item)
        else { return }
        withAnimation {
            items.move(
                fromOffsets: .init(integer: from),
                toOffset: to > from ? to + 1 : to
            )
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
}

#Preview {
    @Previewable @State var items: [IngredientDraftModel] = [
        .init(id: UUID(), name: "400 мл воды"),
        .init(id: UUID(), name: "1 пакетик чая"),
    ]
    
    IngredientsEditView(ingredients: $items)
}
