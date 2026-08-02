#if canImport(UIKit)
import Testing
import UIKit
import ViewInspector
import RecipeUIKit
import TestHelpers
@testable import RecipeEdit

@MainActor
final class RecipeDetailFeature {
    let view: RecipeDetailScreen
    private var host: (UIWindow, UIViewController)?

    init(view: RecipeDetailScreen) {
        self.view = view
    }

    func start() {
        host = hostInWindow(view)
    }

    func finish() {
        host = nil
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

    func ensureIsDisplayingRecipe(_ recipe: Recipe, sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            guard let title = try? self.view.inspect()
                .find(viewWithAccessibilityIdentifier: RecipeTitleViewA11y.component)
                .text()
                .string() else { return false }
            return title == recipe.title
        }
    }

    func tapRetryButton() throws {
        let button = try view.inspect()
            .find(viewWithAccessibilityIdentifier: ErrorViewA11y.retryButton)
            .button()
        try button.tap()
    }
}
#endif
