#if canImport(UIKit)
import Testing
import UIKit
import ViewInspector
import RecipeUIKit
import TestHelpers
@testable import Recipe

@MainActor
final class RecipeCreateFeature {
    let view: RecipeCreateScreen
    private var host: (UIWindow, UIViewController)?

    init(view: RecipeCreateScreen) {
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

    func ensureIsDisplayingEditForm(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let _ = try self.view.inspect().find(viewWithAccessibilityIdentifier: RecipeEditA11y.saveButton)
            return true
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
