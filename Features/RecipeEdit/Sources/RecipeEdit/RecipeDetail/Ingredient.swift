//
//  Ingredient.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 04.07.2026.
//

import SwiftUI

final class IngredientModel: ObservableObject {
    @Published var isOn: Bool = false
    let name: String
    
    init(isOn: Bool, name: String) {
        self.isOn = isOn
        self.name = name
    }
}

struct Ingredient: View {
    @ObservedObject var model: IngredientModel
    
    var body: some View {
        VStack {
            Toggle(isOn: $model.isOn) {
                Text(model.name)
            }
            .toggleStyle(IngredientToggleStyle())
            .tint(Color.black)
        }
    }
}

private struct IngredientToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                NotesCheckbox(isOn: configuration.isOn)
                configuration.label
            }
        }
    }
}

#Preview {
    let model = IngredientModel(isOn: false, name: "Куриное филе")
    Ingredient(model: model)
}
