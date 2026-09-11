//
//  RecipeStepDraftModel.swift
//  Recipe
//
//  Created by Марина Чемезова on 04.09.2026.
//

import Foundation

struct RecipeStepDraftModel: Sendable, Identifiable {
    let id: UUID
    var title: String
    var imageSource: URL?
    var text: String
}
