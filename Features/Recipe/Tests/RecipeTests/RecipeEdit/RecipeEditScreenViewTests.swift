#if canImport(UIKit)
import Foundation
import Testing
import UIKit
import TestHelpers

@testable import Recipe

@MainActor
struct RecipeEditScreenViewTests {
    let leakChecker = LeakChecker()

    @Test func showsSaveButton() async throws {
        do {
            let (feature, _) = makeSUT()
            feature.start()

            try feature.userTapsSave()

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func showsSavingIndicator() async throws {
        do {
            let (feature, viewModel) = makeSUT()
            leakChecker.track(feature)
            viewModel.isSaving = true
            feature.start()

            try await feature.ensureIsSaving()

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func showsSavingOverlay() async throws {
        do {
            let (feature, viewModel) = makeSUT()
            leakChecker.track(feature)
            viewModel.isSaving = true
            feature.start()

            try await feature.ensureFormIsDisabled()

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func showsTitleValidationError() async throws {
        do {
            let (feature, viewModel) = makeSUT()
            leakChecker.track(feature)
            viewModel.fieldErrors = ["title": String(localized: .titleRequiredValidationError)]
            feature.start()

            try await feature.ensureIsDisplayingTitleValidationError(
                String(localized: .titleRequiredValidationError)
            )

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func tapSaveCallsOnSubmit() async throws {
        do {
            var onSubmitCalled = false
            let (feature, viewModel) = makeSUT()
            viewModel.onSubmitTapped = { onSubmitCalled = true }
            feature.start()

            try feature.userTapsSave()

            #expect(onSubmitCalled)
            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    // MARK: - Helpers

    private func makeSUT() -> (RecipeEditModalFeature, RecipeEditViewModel) {
        let draftModel = RecipeDraftModel(
            id: UUID(),
            title: "Рецепт",
            description: "",
            ingredients: [],
            topTextBlock: nil,
            steps: [],
            bottomTextBlock: nil
        )
        let viewModel = RecipeEditViewModel(model: draftModel)
        let screen = RecipeEditScreen(viewModel: viewModel)
        let feature = RecipeEditModalFeature(view: screen)
        leakChecker.track(viewModel)
        leakChecker.track(feature)
        return (feature, viewModel)
    }
}
#endif
