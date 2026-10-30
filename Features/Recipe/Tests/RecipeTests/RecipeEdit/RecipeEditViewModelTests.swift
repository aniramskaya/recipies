import Foundation
import Testing
import TestHelpers

@testable import Recipe

@MainActor
struct RecipeEditViewModelTests {
    let leakChecker = LeakChecker()

    @Test func successfulSave() async throws {
        do {
            var onSaveCompletedCalled = false
            let (viewModel, saver) = makeSUT(onSaveCompleted: { onSaveCompletedCalled = true })

            viewModel.onSubmitTapped()

            await waitFor { saver.saveCount > 0 }
            try await saver.respond(with: .success(()), at: 0)

            await waitFor { !viewModel.isSaving }
            #expect(onSaveCompletedCalled)
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func emptyTitleSetsValidationError() async throws {
        do {
            let (viewModel, saver) = makeSUT(title: "")

            viewModel.onSubmitTapped()

            await waitFor { viewModel.fieldErrors["title"] != nil }
            #expect(saver.saveCount == 0)
        }
        await leakChecker.awaitAllReleased()
    }

    // MARK: - Helpers

    private func makeSUT(
        title: String = "Рецепт",
        onSaveCompleted: @escaping () -> Void = {}
    ) -> (RecipeEditViewModel, RecipeEditSaverStub) {
        let saver = RecipeEditSaverStub()
        let deleter = RecipeDeleterStub()
        let draftModel = RecipeDraftModel(
            id: UUID(),
            title: title,
            description: "",
            ingredients: [],
            topTextBlock: nil,
            steps: [],
            bottomTextBlock: nil
        )
        let viewModel = RecipeEditScreenAssembly.composeViewModel(
            model: draftModel,
            saver: saver,
            deleter: deleter,
            onCancel: {},
            onSaveCompleted: onSaveCompleted,
            onDeleteCompleted: {}
        )
        leakChecker.track(saver)
        leakChecker.track(deleter)
        leakChecker.track(viewModel)
        return (viewModel, saver)
    }
}
