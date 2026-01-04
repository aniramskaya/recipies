//
//  RecipeListRowTests.swift
//  RecipieListTests
//
//  Created by Марина Чемезова on 23.12.2025.
//

import Foundation
import Testing
import SnapshotTesting

struct RecipeListRowTests {
    @MainActor
    @Test func RecipeListRowSnapshot() async throws {
        let view = RecipeListRow(
            model: .init(
                id: UUID(uuidString: "b0a1a334-09b3-4e61-87bf-0b05745388cf")!,
                name: "Котлета по-киевски",
                imageSource: .uiImage(.make(withColor: .red)),
                cookingTimeMins: 35,
                rating: 4.6
            )
        )
        
        assertSnapshot(of: view, as: .image(precision: 0.98, layout: .fixed(width: 375, height: 270)))
    }

}
