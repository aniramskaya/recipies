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
        // TODO: waitFor — найти LoadingView в иерархии вью
    }

    func ensureIsDisplayingError(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        // TODO: waitFor — найти ErrorView в иерархии вью
    }

    func ensureIsDisplayingForm(data: RecipeData, sourceLocation: SourceLocation = #_sourceLocation) async throws {
        // TODO: waitFor — проверить что форма отображает name, cookingTime и complexity из data
    }

    // MARK: RecipeEditUser

    func tapRetryButton() throws {
        // TODO: найти кнопку повтора через ErrorViewA11y.retryButton и нажать
    }
}
#endif
