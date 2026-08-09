//
//  RecipeEditScreen.swift
//  Recipe
//
//  Created by Марина Чемезова on 09.08.2026.
//

import SwiftUI

public struct RecipeEditScreen: View {
    private var model: RecipeDraftModel

    init(model: RecipeDraftModel) {
        self.model = model
    }

    public var body: some View {
        RecipeEditView(dataModel: model)
    }
}
