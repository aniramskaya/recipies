#if canImport(UIKit)
import Foundation
import Testing
import UIKit
import RecipeTypes
import RecipeUIKit
import TestHelpers

@testable import Recipe

@MainActor
struct RecipeCreateScreenViewTests {
    let leakChecker = LeakChecker()

    @Test func showsLoadingView() async throws {
        do {
            let feature = makeFeature(state: .loading)
            leakChecker.track(feature)
            feature.start()

            try await feature.ensureIsDisplayingLoadingState()
            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func showsErrorView() async throws {
        do {
            let feature = makeFeature(state: .failed(NSError.any()))
            leakChecker.track(feature)
            feature.start()

            try await feature.ensureIsDisplayingError()
            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func showsEditFormWhenLoaded() async throws {
        do {
            let feature = makeFeature(state: .loaded(testDraftModel()))
            leakChecker.track(feature)
            feature.start()

            try await feature.ensureIsDisplayingEditForm()
            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func tapRetryCallsOnRetry() async throws {
        do {
            var retryCalled = false
            let feature = makeFeature(state: .failed(NSError.any()), onRetry: { retryCalled = true })
            leakChecker.track(feature)
            feature.start()

            try await feature.ensureIsDisplayingError()
            try feature.tapRetryButton()

            #expect(retryCalled)
            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    // MARK: - Helpers

    private func makeFeature(
        state: ResourceLoadState<RecipeDraftModel>,
        onRetry: (() -> Void)? = nil
    ) -> RecipeCreateFeature {
        let viewModel = RecipeCreateScreenViewModel(state: state)
        if let onRetry {
            viewModel.onRetry = onRetry
        }
        let screen = RecipeCreateScreen(
            viewModel: viewModel,
            saver: RecipeEditSaverStub(),
            deleter: RecipeDeleterStub()
        )
        return RecipeCreateFeature(view: screen)
    }
}

@MainActor
private func testDraftModel() -> RecipeDraftModel {
    RecipeDraftModel(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
        title: "Новый рецепт",
        description: "",
        ingredients: [],
        topTextBlock: nil,
        steps: [],
        bottomTextBlock: nil
    )
}
#endif
