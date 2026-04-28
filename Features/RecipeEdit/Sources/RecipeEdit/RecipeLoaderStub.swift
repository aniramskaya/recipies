//
//  RecipeLoaderStub.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 27.04.2026.
//

import Foundation

final class RecipeLoaderStub: RecipeLoader {
    func load() async throws -> RecipeData {
        try await withCheckedThrowingContinuation({ continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                continuation.resume(returning: RecipeData(id: UUID(), name: "Sample recipe", cookingTime: 45, complexity: 3))
            }
        })
        
    }
}
