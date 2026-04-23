import Testing
import SnapshotTesting
import SwiftUI
@testable import EditRecipe

struct EditRecipeViewTests {
    @MainActor
    @Test func filledFormSnapshot() async throws {
        let view = makeSUT(data: .filled, errors: .none)
        assertSnapshot(of: view, as: .image(precision: 0.99, layout: .fixed(width: 375, height: 550)))
    }

    @MainActor
    @Test func formWithValidationErrorsSnapshot() async throws {
        let view = makeSUT(data: .empty, errors: .allRequired)
        assertSnapshot(of: view, as: .image(precision: 0.99, layout: .fixed(width: 375, height: 550)))
    }

    private func makeSUT(data: EditRecipeFormData, errors: EditRecipeFormErrors) -> some View {
        EditRecipeView(data: data, errors: errors, onSave: {})
    }
}

private extension EditRecipeFormData {
    static let filled = EditRecipeFormData(
        name: "Котлета по-киевски",
        cookingTime: "35",
        complexity: 3
    )
}

private extension EditRecipeFormErrors {
    static let allRequired = EditRecipeFormErrors(
        name: "Поле обязательно",
        cookingTime: "Поле обязательно",
        complexity: nil
    )
}
