import Foundation
import Testing
import RecipeTypes
import TestHelpers

@testable import Recipe

@MainActor
struct RecipeCreateViewModelTests {
    let leakChecker = LeakChecker()

    @Test func initialStateIsLoading() async {
        do {
            let (viewModel, _) = makeSUT()

            if case .loading = viewModel.state { } else {
                Issue.record("Expected .loading, got \(viewModel.state)")
            }
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func loadsRecipeSuccessfully() async throws {
        do {
            let (viewModel, server) = makeSUT()

            viewModel.onAppear()
            try await server.respond(with: .success(testRecipe()), at: 0)

            await waitFor {
                if case .loaded = viewModel.state { return true }
                return false
            }
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func loadsRecipeAsDraftModel() async throws {
        do {
            let (viewModel, server) = makeSUT()

            viewModel.onAppear()
            try await server.respond(with: .success(testRecipe()), at: 0)

            await waitFor {
                if case .loaded(let draft) = viewModel.state {
                    return draft.title == testRecipe().title
                }
                return false
            }
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func showsErrorOnLoadFailure() async throws {
        do {
            let (viewModel, server) = makeSUT()

            viewModel.onAppear()
            try await server.respond(with: .failure(NSError.any()), at: 0)

            await waitFor {
                if case .failed = viewModel.state { return true }
                return false
            }
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func retriesAfterFailure() async throws {
        do {
            let (viewModel, server) = makeSUT()

            viewModel.onAppear()
            try await server.respond(with: .failure(NSError.any()), at: 0)

            await waitFor {
                if case .failed = viewModel.state { return true }
                return false
            }

            viewModel.onRetry()
            try await server.respond(with: .success(testRecipe()), at: 1)

            await waitFor {
                if case .loaded = viewModel.state { return true }
                return false
            }
        }
        await leakChecker.awaitAllReleased()
    }

    // MARK: - Helpers

    private func makeSUT() -> (RecipeCreateScreenViewModel, RecipeDetailServer) {
        let server = RecipeDetailServer()
        let viewModel = RecipeCreateScreenAssembly.composeModel(loader: server)
        leakChecker.track(server)
        leakChecker.track(viewModel)
        return (viewModel, server)
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
