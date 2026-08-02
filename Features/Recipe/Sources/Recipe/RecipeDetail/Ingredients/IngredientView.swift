//
//  IngredientView.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 04.07.2026.
//

import SwiftUI

@Observable
final class IngredientModel {
    var isOn: Bool = false
    let name: String

    init(isOn: Bool, name: String) {
        self.isOn = isOn
        self.name = name
    }
}

struct IngredientView: View {
    @Bindable var model: IngredientModel
    
    var body: some View {
        Toggle(isOn: $model.isOn) {
            Text(model.name)
                .multilineTextAlignment(.leading)
                .accessibilityIdentifier(IngredientViewA11y.name)
        }
        .toggleStyle(IngredientToggleStyle())
        .tint(Color.primary)
        .accessibilityIdentifier(IngredientViewA11y.component)
    }
}

private struct IngredientToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack(alignment: .top) {
                NotesCheckbox(isOn: configuration.isOn)
                configuration.label
                    .opacity(configuration.isOn ? 0.4 : 1)
            }
        }
    }
}

enum IngredientViewA11y {
    static let component = "Ingredient"
    static let name = "Name"
}

#Preview {
    let model = IngredientModel(isOn: false, name: "Куриное филе")
    IngredientView(model: model)
}
