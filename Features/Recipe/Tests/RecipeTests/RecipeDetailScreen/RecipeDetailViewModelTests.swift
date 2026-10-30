import Foundation
import Testing
import RecipeUIKit
import RecipeTypes
import TestHelpers

@testable import Recipe

@MainActor
struct RecipeDetailViewModelTests {
    let leakChecker = LeakChecker()

    @Test func initialStateIsLoading() async {
        do {
            let server = RecipeDetailServer()
            let (model, leakable) = RecipeDetailScreenAssembly.composeModel(loader: server)
            leakChecker.track(server)
            leakChecker.track(leakable)
            leakChecker.track(model)

            if case .loading = model.loadingState { } else {
                Issue.record("Expected .loading, got \(model.loadingState)")
            }
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func loadsRecipeSuccessfully() async throws {
        do {
            let server = RecipeDetailServer()
            let (model, leakable) = RecipeDetailScreenAssembly.composeModel(loader: server)
            leakChecker.track(server)
            leakChecker.track(leakable)
            leakChecker.track(model)

            model.onAppear()
            try await server.respond(with: .success(testRecipe()), at: 0)

            await waitFor {
                if case .loaded = model.loadingState { return true }
                return false
            }
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func showsErrorOnLoadFailure() async throws {
        do {
            let server = RecipeDetailServer()
            let (model, leakable) = RecipeDetailScreenAssembly.composeModel(loader: server)
            leakChecker.track(server)
            leakChecker.track(leakable)
            leakChecker.track(model)

            model.onAppear()
            try await server.respond(with: .failure(NSError.any()), at: 0)

            await waitFor {
                if case .failed = model.loadingState { return true }
                return false
            }
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func retriesAfterFailure() async throws {
        do {
            let server = RecipeDetailServer()
            let (model, leakable) = RecipeDetailScreenAssembly.composeModel(loader: server)
            leakChecker.track(server)
            leakChecker.track(leakable)
            leakChecker.track(model)

            model.onAppear()
            try await server.respond(with: .failure(NSError.any()), at: 0)

            await waitFor {
                if case .failed = model.loadingState { return true }
                return false
            }

            model.onRetry()
            try await server.respond(with: .success(testRecipe()), at: 1)

            await waitFor {
                if case .loaded = model.loadingState { return true }
                return false
            }
        }
        await leakChecker.awaitAllReleased()
    }
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
