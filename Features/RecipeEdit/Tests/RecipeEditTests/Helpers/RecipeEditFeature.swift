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
    func tapSaveButton() throws
    func fillNameField(_ text: String) throws
    func fillCookingTimeField(_ text: String) throws
    func tapCloseErrorOverlay() throws
}

// MARK: - Feature DSL

@MainActor
final class RecipeEditFeature: RecipeEditUser {
    let view: RecipeEditScreen<RecipeEditView>
    private var host: (UIWindow, UIViewController)?

    init(view: RecipeEditScreen<RecipeEditView>) {
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

    func ensureIsDisplayingNameError(_ message: String, sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let text = try self.view.inspect()
                .find(viewWithAccessibilityIdentifier: RecipeEditA11y.nameError)
                .text()
                .string()
            return text == message
        }
    }

    func ensureIsDisplayingCookingTimeError(_ message: String, sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let text = try self.view.inspect()
                .find(viewWithAccessibilityIdentifier: RecipeEditA11y.cookingTimeError)
                .text()
                .string()
            return text == message
        }
    }

    func ensureIsDisplayingNoValidationErrors(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let inspectable = try self.view.inspect()
            let hasNameError = (try? inspectable.find(viewWithAccessibilityIdentifier: RecipeEditA11y.nameError)) != nil
            let hasCookingTimeError = (try? inspectable.find(viewWithAccessibilityIdentifier: RecipeEditA11y.cookingTimeError)) != nil
            let hasComplexityError = (try? inspectable.find(viewWithAccessibilityIdentifier: RecipeEditA11y.complexityError)) != nil
            return !hasNameError && !hasCookingTimeError && !hasComplexityError
        }
    }

    // MARK: RecipeEditUser

    func tapRetryButton() throws {
        let button = try view.inspect()
            .find(viewWithAccessibilityIdentifier: ErrorViewA11y.retryButton)
            .button()
        try button.tap()
    }

    func tapSaveButton() throws {
        let button = try view.inspect()
            .find(viewWithAccessibilityIdentifier: RecipeEditA11y.saveButton)
            .button()
        try button.tap()
    }

    func fillNameField(_ text: String) throws {
        let field = try view.inspect()
            .find(viewWithAccessibilityIdentifier: RecipeEditA11y.nameField)
            .textField()
        try field.setInput(text)
    }

    func fillCookingTimeField(_ text: String) throws {
        let field = try view.inspect()
            .find(viewWithAccessibilityIdentifier: RecipeEditA11y.cookingTimeField)
            .textField()
        try field.setInput(text)
    }

    func tapCloseErrorOverlay() throws {
        let button = try view.inspect()
            .find(viewWithAccessibilityIdentifier: RecipeEditA11y.errorOverlayCloseButton)
            .button()
        try button.tap()
    }

    func ensureIsDisplayingSuccessOverlay(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let _ = try self.view.inspect().find(viewWithAccessibilityIdentifier: RecipeEditA11y.successOverlay)
            return true
        }
    }

    func ensureIsDisplayingErrorOverlay(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let _ = try self.view.inspect().find(viewWithAccessibilityIdentifier: RecipeEditA11y.errorOverlay)
            return true
        }
    }

    func ensureIsDisplayingNoSavingOverlay(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(timeout: 2.2, sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let inspectable = try self.view.inspect()
            let hasSaving = (try? inspectable.find(viewWithAccessibilityIdentifier: RecipeEditA11y.savingOverlay)) != nil
            let hasSuccess = (try? inspectable.find(viewWithAccessibilityIdentifier: RecipeEditA11y.successOverlay)) != nil
            let hasError = (try? inspectable.find(viewWithAccessibilityIdentifier: RecipeEditA11y.errorOverlay)) != nil
            return !hasSaving && !hasSuccess && !hasError
        }
    }
}
#endif
