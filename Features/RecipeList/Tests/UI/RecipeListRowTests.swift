//
//  RecipeListRowTests.swift
//  RecipieListTests
//
//  Created by Марина Чемезова on 23.12.2025.
//

import Foundation
import Testing
import SnapshotTesting
import RecipeUIKit
import ViewInspector
@testable import RecipieList

typealias A11y = RecipeListRowA11y

struct RecipeListRowTests {
    @MainActor
    @Test func RecipeListRowSnapshot() async throws {
        let view = makeSUT()
        
        assertSnapshot(of: view, as: .image(precision: 0.99, layout: .fixed(width: 375, height: 270)))
    }

    @MainActor
    @Test("RecipeListRow правильно отображает контент")
    func RecipeListRowContent() async throws {
        let sut = makeSUT()
        
        #expect(throws: Never.self) {
            try sut.assertIsDisplaying(name: "Котлета по-киевски", rating: "4.6", cookingTime: "35 min")
        }
    }
    
    private func makeSUT() -> RecipeListRow {
        .init(model: testModel)
    }
}

let testModel = RecipeListRowModel(
    id: UUID(uuidString: "b0a1a334-09b3-4e61-87bf-0b05745388cf")!,
    name: "Котлета по-киевски",
    imageSource: .uiImage(.make(withColor: .red)),
    cookingTimeMins: 35,
    rating: 4.6
)
