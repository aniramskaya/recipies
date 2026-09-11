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

    @MainActor
    public static func composeModal(model: RecipeDraftModel, onCancel: @escaping () -> Void, onSave: @escaping () -> Void) -> some View {
        RecipeEditScreenModal(model: model, onCancel: onCancel, onSave: onSave)
    }
    
    @MainActor
    public static func composeNewRecipe(onCancel: @escaping () -> Void, onSave: @escaping () -> Void) -> some View {
        RecipeEditScreenModal(model: .empty, onCancel: onCancel, onSave: onSave)
    }
}
