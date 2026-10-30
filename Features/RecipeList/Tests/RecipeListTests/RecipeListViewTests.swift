//
//  RecipeListViewTests.swift
//  RecipeListTests
//

import Testing
import SwiftUI
import UIKit
import RecipeUIKit
import TestHelpers
import ViewInspector

@testable import RecipeList

@MainActor
struct RecipeListViewTests {
    let leakChecker = LeakChecker()

    @Test func showsLoadingView() async throws {
        do {
            let feature = makeFeature(state: .loading)
            leakChecker.track(feature)
            feature.start()

            try await feature.ensureIsDisplayingLoadingState()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func showsErrorView() async throws {
        do {
            let feature = makeFeature(state: .failed(NSError.any()))
            leakChecker.track(feature)
            feature.start()

            try await feature.ensureIsDisplayingError(text: "Не удалось загрузить список рецептов")
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func showsListData() async throws {
        do {
            let feature = makeFeature(state: .loaded(RecipeListItem.makeTestItems().asViewModels()))
            leakChecker.track(feature)
            feature.start()

            try await feature.ensureIsDisplayingData(model: testModels())
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func tapRetryCallsOnRetry() async throws {
        do {
            var retryCalled = false
            let feature = makeFeature(state: .failed(NSError.any()), onRetry: { retryCalled = true })
            leakChecker.track(feature)
            feature.start()

            try await feature.ensureIsDisplayingError(text: "Не удалось загрузить список рецептов")
            try feature.tapReloadButton()

            #expect(retryCalled)
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func tapListItemCallsOnSelectItem() async throws {
        do {
            var selectedIDs: [UUID] = []
            let feature = makeFeature(
                state: .loaded(RecipeListItem.makeTestItems().asViewModels()),
                onSelectItem: { id, _ in selectedIDs.append(id) }
            )
            leakChecker.track(feature)
            feature.start()

            try await feature.ensureIsDisplayingData(model: testModels())
            try feature.tapListItem(at: 0)

            #expect(selectedIDs == [UUID(uuidString: "c1fb3a12-62fc-401e-861f-11594fe87c32")!])
        }
        await leakChecker.awaitAllReleased()
    }

    // MARK: - Helpers

    private func makeFeature(
        state: ResourceLoadState<[RecipeListRowModel]>,
        onRetry: (() -> Void)? = nil,
        onSelectItem: (@MainActor (_ id: UUID, _ isDraft: Bool) -> Void)? = nil
    ) -> RecipeListFeature {
        let viewModel = RecipeListScreenViewModel()
        viewModel.state = state
        if let onRetry {
            viewModel.onRetry = onRetry
        }
        let screen = RecipeListScreen(viewModel: viewModel, onSelectItem: onSelectItem ?? { _, _ in })
        return RecipeListFeature(view: screen)
    }
}

private func testModels() -> [(name: String, complexity: Int, cookingTime: String)] {
    [
        (name: "Котлеты по-киевски", complexity: 3, cookingTime: "75 min"),
        (name: "Лапша Удон с курицей", complexity: 2, cookingTime: "35 min"),
    ]
}
