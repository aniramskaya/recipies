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
        let view = RecipeListRow(
            model: .init(
                id: UUID(uuidString: "b0a1a334-09b3-4e61-87bf-0b05745388cf")!,
                name: "Котлета по-киевски",
                imageSource: .uiImage(.make(withColor: .red)),
                cookingTimeMins: 35,
                rating: 4.6
            )
        )
        
        assertSnapshot(of: view, as: .image(precision: 0.99, layout: .fixed(width: 375, height: 270)))
    }

    @MainActor
    @Test("RecipeListRow правильно отображает контент")
    func RecipeListRowContent() async throws {
        let sut = RecipeListRow(
            model: .init(
                id: UUID(uuidString: "b0a1a334-09b3-4e61-87bf-0b05745388cf")!,
                name: "Котлета по-киевски",
                imageSource: .uiImage(.make(withColor: .red)),
                cookingTimeMins: 35,
                rating: 4.6
            )
        )
        
        let inspectable = try sut.inspect()
        
        let name = try inspectable.find(viewWithAccessibilityIdentifier: A11y.name).text().string()
        #expect(name == "Котлета по-киевски")

        #expect(throws: Never.self) {
            let _ = try inspectable.find(viewWithAccessibilityIdentifier: A11y.rating).find(text: "4.6")
        }
        
        #expect(throws: Never.self) {
            let _ = try inspectable.find(viewWithAccessibilityIdentifier: A11y.cookingTime).find(text: "35 min")
        }
    }
}
