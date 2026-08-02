import Testing
import SnapshotTesting
import SwiftUI
@testable import Recipe

struct RecipeEditViewTests {
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
        await RecipeEditViewTestWrapper(data: data, errors: errors)
    }
}

private struct RecipeEditViewTestWrapper: View {
    let dataModel: RecipeDataModel
    let viewModel: RecipeEditViewModel

    init(data: RecipeEditFormData, errors: RecipeEditFormErrors) {
        dataModel = .init()
        dataModel.name = data.name
        dataModel.cookingTime = data.cookingTime
        dataModel.complexity = data.complexity
        
        viewModel = .init()
        viewModel.errors = errors
    }

    var body: some View {
        RecipeEditView(dataModel: dataModel, viewModel: viewModel)
    }
}

private struct RecipeEditFormData {
    let name: String
    let cookingTime: String
    let complexity: Int

    static let empty = RecipeEditFormData(name: "", cookingTime: "", complexity: 1)
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
