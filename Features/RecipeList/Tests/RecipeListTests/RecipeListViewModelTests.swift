//
//  RecipeListViewModelTests.swift
//  RecipeListTests
//

import Testing
import Foundation
import RecipeUIKit
import TestHelpers

@testable import RecipeList

@MainActor
struct RecipeListViewModelTests {
    let leakChecker = LeakChecker()

    @Test func initialStateIsLoading() async {
        do {
            let server = AsyncServer()
            let viewModel = RecipeListModelAssembly.composeModel(loader: server)
            leakChecker.track([server, viewModel])

            if case .loading = viewModel.state { } else {
                Issue.record("Expected .loading, got \(viewModel.state)")
            }
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func loadsRecipesSuccessfully() async throws {
        do {
            let server = AsyncServer()
            let viewModel = RecipeListModelAssembly.composeModel(loader: server)
            leakChecker.track([server, viewModel])

            viewModel.onAppear()
            try await server.respond(with: .success(RecipeListItem.makeTestItems()), at: 0)

            await waitFor {
                if case .loaded(let items) = viewModel.state {
                    return items.count == 2
                }
                return false
            }
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func showsErrorOnLoadFailure() async throws {
        do {
            let server = AsyncServer()
            let viewModel = RecipeListModelAssembly.composeModel(loader: server)
            leakChecker.track([server, viewModel])

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
            let server = AsyncServer()
            let viewModel = RecipeListModelAssembly.composeModel(loader: server)
            leakChecker.track([server, viewModel])

            viewModel.onAppear()
            try await server.respond(with: .failure(NSError.any()), at: 0)

            await waitFor {
                if case .failed = viewModel.state { return true }
                return false
            }

            viewModel.onRetry()
            try await server.respond(with: .success(RecipeListItem.makeTestItems()), at: 1)

            await waitFor {
                if case .loaded(let items) = viewModel.state {
                    return items.count == 2
                }
                return false
            }
        }
        await leakChecker.awaitAllReleased()
    }
}
