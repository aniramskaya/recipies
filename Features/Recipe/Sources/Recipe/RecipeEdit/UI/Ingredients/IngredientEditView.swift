//
//  IngredientEditView.swift
//  Recipe
//
//  Created by Марина Чемезова on 07.08.2026.
//

import SwiftUI
import RecipeUIKit

struct IngredientEditView<Handle: View>: View {
    @Binding var ingredient: IngredientDraftModel
    let onDelete: () -> Void
    let onMoveUp: () -> Void
    let onMoveDown: () -> Void
    let handle: Handle
    
    // Accessibility
    let requestAccessibilityFocus: Bool
    @AccessibilityFocusState private var isAccessibilityFocused: Bool
    
    init(
        ingredient: Binding<IngredientDraftModel>,
        onDelete: @escaping () -> Void,
        onMoveUp: @escaping () -> Void,
        onMoveDown: @escaping () -> Void,
        requestAccessibilityFocus: Bool,
        @ViewBuilder handle: () -> Handle
    ) {
        self._ingredient = ingredient
        self.onDelete = onDelete
        self.onMoveUp = onMoveUp
        self.onMoveDown = onMoveDown
        self.requestAccessibilityFocus = requestAccessibilityFocus
        self.handle = handle()
    }

    var body: some View {
        HStack(
            alignment: .center,
            spacing: 0
        ) {
            Button(action: onDelete) {
                Image(systemName: "minus.circle")
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.red)
                    .background(.background, in: .circle)
            }
            .accessibilityHidden(true)

            // TODO: Разобраться со строками из ресурсов
            TextField(String(localized: .quantityAndName), text: $ingredient.name)
                .accessibilityIdentifier(A11y.textField)
                .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 10))
                .background(
                    RoundedRectangle(cornerRadius: RecipeStyles.Radius.small)
                        .fill(RecipeUIKitAssets.Color.fieldBackground)
                )
                .accessibilityFocused($isAccessibilityFocused)
                .accessibilityActions {
                    Button(.moveUp, action: onMoveUp)
                    Button(.moveDown, action: onMoveDown)
                    Button(.deleteIngredient, action: onDelete)
                }
            
            handle
        }
        .accessibilityIdentifier(A11y.component)
        .onChange(of: requestAccessibilityFocus) { _, newValue in
            guard newValue else { return }
            isAccessibilityFocused = true
        }
    }
}

private typealias A11y = IngredientEditViewA11y

enum IngredientEditViewA11y {
    static let component = "IngredientEditView"
    static let textField = "IngredientEditView.TextField"
}

#Preview {
    @Previewable @State var value = IngredientDraftModel(id: .init(), name: "Секретный ингредиент")

    IngredientEditView(ingredient: $value, onDelete: {}, onMoveUp: {}, onMoveDown: {}, requestAccessibilityFocus: false) {
        DragHandleView(width: 16, lineHeight: 2, spacing: 3)
            .padding(8)
    }
}
