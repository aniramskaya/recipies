import Testing
import SnapshotTesting
import SwiftUI
@testable import RecipeEdit

struct EditRecipeViewTests {
    @MainActor
    @Test func filledFormSnapshot() async throws {
        let view = await makeSUT(data: .filled, errors: .none)
        assertSnapshot(of: view, as: .image(precision: 0.99, layout: .fixed(width: 375, height: 550)))
    }

    @MainActor
    @Test func formWithValidationErrorsSnapshot() async throws {
        let view = await makeSUT(data: .empty, errors: .allRequired)
        assertSnapshot(of: view, as: .image(precision: 0.99, layout: .fixed(width: 375, height: 550)))
    }

    private func makeSUT(data: RecipeEditFormData, errors: RecipeEditFormErrors) async -> some View {
        await RecipeEditView(data: data, errors: errors, onSave: {})
    }
}

private extension RecipeEditFormData {
    static let filled = RecipeEditFormData(
        name: "Котлета по-киевски",
        cookingTime: "35",
        complexity: 3
    )
}

private extension RecipeEditFormErrors {
    static let allRequired = RecipeEditFormErrors(
        name: "Поле обязательно",
        cookingTime: "Поле обязательно",
        complexity: nil
    )
}
