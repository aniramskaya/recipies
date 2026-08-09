//
//  IngredientEditView.swift
//  Recipe
//
//  Created by Марина Чемезова on 07.08.2026.
//

import SwiftUI
import RecipeUIKit

struct IngredientEditView: View {
    @Binding var ingredient: IngredientDraftModel
    @Binding var draggedItem: IngredientDraftModel?
    let onDelete: () -> Void

    var body: some View {
        HStack(
            alignment: .center,
            spacing: 0
        ) {
            Button(action: onDelete) {
                Image(systemName: "minus.circle")
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.red)
            }
            
            // TODO: Разобраться со строками из ресурсов
            TextField("Количество и название", text: $ingredient.name)
                .accessibilityIdentifier(A11y.textField)
                .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 10))
                .background(
                    RoundedRectangle(cornerRadius: RecipeStyles.Radius.small)
                        .fill(RecipeUIKitAssets.Color.fieldBackground)
                )
            
            DragHandleView(width: 16, lineHeight: 2, spacing: 3)
                .padding(8)
                .onDrag {
                    draggedItem = ingredient
                    return NSItemProvider(object: ingredient.id.uuidString as NSString)
                }
        }
        .accessibilityIdentifier(A11y.component)
    }
}

private typealias A11y = IngredientEditViewA11y

enum IngredientEditViewA11y {
    static let component = "IngredientEditView"
    static let textField = "IngredientEditView.TextField"
}
#Preview {
    @Previewable @State var value = IngredientDraftModel(id: .init(), name: "Секретный ингредиент")
    @Previewable @State var dragged: IngredientDraftModel?
    
    IngredientEditView(ingredient: $value, draggedItem: $dragged) {
        
    }
}
