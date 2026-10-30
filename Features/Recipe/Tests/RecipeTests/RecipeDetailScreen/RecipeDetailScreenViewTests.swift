#if canImport(UIKit)
import Foundation
import Testing
import UIKit
import RecipeUIKit
import RecipeTypes
import TestHelpers
import ViewInspector

@testable import Recipe

@MainActor
struct RecipeDetailScreenViewTests {
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

    @Test func showsRecipe() async throws {
        do {
            let feature = makeFeature(state: .loaded(testDetailViewModel()))
            leakChecker.track(feature)
            feature.start()

            try await feature.ensureIsDisplayingRecipe(testRecipe())
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
        state: ResourceLoadState<RecipeDetailViewModel>,
        onRetry: (() -> Void)? = nil
    ) -> RecipeDetailFeature {
        let model = RecipeDetailScreenModel()
        model.loadingState = state
        if let onRetry {
            model.onRetry = onRetry
        }
        return RecipeDetailFeature(view: RecipeDetailScreen(viewModel: model))
    }
}

private func testDetailViewModel() -> RecipeDetailViewModel {
    RecipeDetailViewModel(
        imageSource: .system("photo"),
        cookingTimeMins: 50,
        complexity: 3,
        title: "Баттер Чикен",
        description: nil,
        ingredients: IngredientListModel(items: []),
        topText: nil,
        steps: [],
        bottomText: nil,
        onShare: {}
    )
}

private func testRecipe() -> Recipe {
    Recipe(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
        imageSource: URL(string: "https://example.com/image.jpg")!,
        cookingTimeMins: 50,
        complexity: 3,
        title: "Баттер Чикен",
        description: nil,
        ingredients: [Ingredient(id: UUID(), name: "Куриное филе")],
        topText: nil,
        steps: [RecipeStep(id: UUID(), title: "Шаг", imageSource: nil, text: "Описание")],
        bottomText: nil
    )
}
#endif
