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
            let (model, _) = makeSUT()

            if case .loading = model.loadingState { } else {
                Issue.record("Expected .loading, got \(model.loadingState)")
            }
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func loadsRecipeSuccessfully() async throws {
        do {
            let (model, server) = makeSUT()

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
            let (model, server) = makeSUT()

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
            let (model, server) = makeSUT()

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

    @Test func editPassesLoadedRecipeAsDraftModel() async throws {
        do {
            var receivedDraft: RecipeDraftModel?
            let (model, server) = makeSUT(onEdit: { draft, _ in receivedDraft = draft })

            model.onAppear()
            try await server.respond(with: .success(testRecipe()), at: 0)

            await waitFor {
                if case .loaded = model.loadingState { return true }
                return false
            }

            model.onEdit()

            #expect(receivedDraft?.title == testRecipe().title)
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func editDoesNothingBeforeLoad() async {
        do {
            var onEditCalled = false
            let (model, _) = makeSUT(onEdit: { _, _ in onEditCalled = true })

            model.onEdit()

            #expect(!onEditCalled)
        }
        await leakChecker.awaitAllReleased()
    }

    // MARK: - Helpers

    private func makeSUT(
        onEdit: @escaping (RecipeDraftModel, @escaping () -> Void) -> Void = { _, _ in }
    ) -> (RecipeDetailScreenModel, RecipeDetailServer) {
        let server = RecipeDetailServer()
        let (model, leakable) = RecipeDetailScreenAssembly.composeModel(loader: server, onEdit: onEdit)
        leakChecker.track(server)
        leakChecker.track(leakable)
        leakChecker.track(model)
        return (model, server)
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
