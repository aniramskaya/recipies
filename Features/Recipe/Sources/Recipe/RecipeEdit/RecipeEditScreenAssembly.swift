//
//  RecipeEditScreenAssembly.swift
//  Recipe
//
//  Created by Марина Чемезова on 09.08.2026.
//

import SwiftUI

public enum RecipeEditScreenAssembly {
    @MainActor
    public static func compose(model: RecipeDraftModel) -> some View {
        RecipeEditScreen(model: model)
    }
}
