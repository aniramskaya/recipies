#if canImport(UIKit)
import Testing
import UIKit
import SwiftUI
import ViewInspector
import RecipeUIKit
@testable import RecipeEdit

// MARK: - User protocol

@MainActor
protocol RecipeEditUser {
    func tapRetryButton() throws
}

// MARK: - Feature DSL

@MainActor
final class RecipeEditFeature: RecipeEditUser {
    let view: RecipeEditScreen
    private var host: (UIWindow, UIViewController)?

    init(view: RecipeEditScreen) {
        self.view = view
    }

    func start() {
        host = hostInWindow(view)
    }

    func ensureIsDisplayingLoadingState(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let _ = try self.view.inspect().find(viewWithAccessibilityIdentifier: LoadingViewA11y.component)
            return true
        }
    }

    func ensureIsDisplayingError(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let _ = try self.view.inspect().find(viewWithAccessibilityIdentifier: ErrorViewA11y.component)
            return true
        }
    }

    func ensureIsDisplayingForm(data: RecipeData, sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let inspectable = try self.view.inspect()

            let name = try inspectable
                .find(viewWithAccessibilityIdentifier: RecipeEditA11y.nameField)
                .textField()
                .input()
            guard name == data.name else { return false }

            let cookingTime = try inspectable
                .find(viewWithAccessibilityIdentifier: RecipeEditA11y.cookingTimeField)
                .textField()
                .input()
            guard cookingTime == String(data.cookingTime) else { return false }

            let complexity = try inspectable
                .find(viewWithAccessibilityIdentifier: RecipeEditA11y.complexityValue)
                .text()
                .string()
            guard complexity == String(data.complexity) else { return false }

            return true
        }
    }

    // MARK: RecipeEditUser

    func tapRetryButton() throws {
        let button = try view.inspect()
            .find(viewWithAccessibilityIdentifier: ErrorViewA11y.retryButton)
            .button()
        try button.tap()
    }
}
#endif
