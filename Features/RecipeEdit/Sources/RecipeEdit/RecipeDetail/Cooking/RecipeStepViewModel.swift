//
//  RecipeStepViewModel.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 20.07.2026.
//

import Foundation
import RecipeUIKit

struct RecipeStepViewModel: Identifiable {
    let id: UUID
    let title: String
    let imageSource: RecipeImageSource?
    let text: String
}
