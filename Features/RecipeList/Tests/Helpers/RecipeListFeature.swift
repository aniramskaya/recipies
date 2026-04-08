//
//  RecipeListFeature.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//
import Testing
import SwiftUI
import UIKit
import ViewInspector
import TestHelpers

@testable import RecipeList

@MainActor
protocol RecipeListUser {
    func tapReloadButton() throws
    func pullToRefresh() throws
}

@MainActor
final class RecipeListFeature: RecipeListUser {
    let view: RecipeListScreen
    var host: (UIWindow, UIViewController)?
    
    init(view: RecipeListScreen) {
        self.view = view
    }
    
    func start() {
        host = hostInWindow(view)
    }
    
    @MainActor
    func ensureIsDisplayingLoadingState(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let inspectable = try self.view.inspect()
            let _ = try inspectable.find(viewWithAccessibilityIdentifier: LoadingViewA11y.component)
            return true
        }
    }

    @MainActor
    func ensureIsDisplayingError(text: String, sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let inspectable = try self.view.inspect()
            let errorView = try inspectable.find(viewWithAccessibilityIdentifier: ErrorViewA11y.errorText)
            let errorText = try errorView.text().string()
            return errorText == text
        }
    }
    
    @MainActor
    func ensureIsDisplayingData(model: [(name: String, rating: String, cookingTime: String)], sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let inspectable = try view.inspect()
            let cells = inspectable.findAll(RecipeListRow.self)
            guard cells.count == model.count else {
                throw TestError(reason: "Expected \(model.count) recipe rows, found \(cells.count) instead")
            }
            for (index, cell) in cells.enumerated() {
                let item = model[index]
                try cell.assertIsDisplaying(
                    name: item.name,
                    rating: item.rating,
                    cookingTime: item.cookingTime
                )
            }
            return true
        }
    }
    
    // MARK: RecipeListUser
    
    @MainActor
    func tapReloadButton() throws {
        let inspectable = try view.inspect()
        let reloadButton = try inspectable.find(viewWithAccessibilityIdentifier: ErrorViewA11y.retryButton).button()
        try reloadButton.tap()
    }
    
    @MainActor
    func pullToRefresh() throws {
        let inspectable = try view.inspect()
        Task { @MainActor in
            try await inspectable.find(ViewType.List.self).callRefreshable()
        }
    }
}
