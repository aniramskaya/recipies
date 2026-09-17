//
//  RecipeLoaderStub.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 27.04.2026.
//

import Foundation

final class RecipeLoaderStub: RecipeLoader {
    func load() async throws -> RecipeData {
        RecipeData(
            id: UUID(),
            title: "Sample recipe",
            description: "A sample recipe",
            ingredients: [],
            topTextBlock: nil,
            steps: [],
            bottomTextBlock: nil
        )
    }
}
