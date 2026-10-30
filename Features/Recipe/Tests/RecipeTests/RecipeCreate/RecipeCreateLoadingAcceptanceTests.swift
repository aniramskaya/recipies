#if canImport(UIKit)
import Foundation
import Testing
import UIKit
import RecipeTypes
import TestHelpers
@testable import Recipe

@MainActor
struct RecipeCreateLoadingAcceptanceTests {
    let leakChecker = LeakChecker()

    @Test func loadSuccessScenario() async throws {
        do {
            let (feature, server) = makeFeature()
            feature.start()

            try await feature.ensureIsDisplayingLoadingState()

            try await server.respond(with: .success(testRecipe()), at: 0)

            try await feature.ensureIsDisplayingEditForm()

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func loadFailureRetrySuccessScenario() async throws {
        do {
            let (feature, server) = makeFeature()
            feature.start()

            try await feature.ensureIsDisplayingLoadingState()

            try await server.respond(with: .failure(NSError.any()), at: 0)

            try await feature.ensureIsDisplayingError()

            try feature.tapRetryButton()

            try await feature.ensureIsDisplayingLoadingState()

            try await server.respond(with: .success(testRecipe()), at: 1)

            try await feature.ensureIsDisplayingEditForm()

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func noMemoryLeaksInInterruptedScenario() async throws {
        do {
            let (feature, _) = makeFeature()
            feature.start()

            try await feature.ensureIsDisplayingLoadingState()

            feature.finish()
        }
        await leakChecker.awaitAllReleased(timeout: 3)
    }

    // MARK: - Helpers

    private func makeFeature() -> (RecipeCreateFeature, RecipeDetailServer) {
        let server = RecipeDetailServer()
        let viewModel = RecipeCreateScreenAssembly.composeModel(loader: server)
        let screen = RecipeCreateScreen(
            viewModel: viewModel,
            saver: RecipeEditSaverStub(),
            deleter: RecipeDeleterStub()
        )
        let feature = RecipeCreateFeature(view: screen)
        leakChecker.track(server)
        leakChecker.track(viewModel)
        leakChecker.track(feature)
        return (feature, server)
    }
}

private func testRecipe() -> Recipe {
    Recipe(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
        title: "Новый рецепт",
        description: nil,
        ingredients: [],
        topText: nil,
        steps: [],
        bottomText: nil
    )
}
#endif
