#if canImport(UIKit)
import Testing
import UIKit
import ViewInspector
import TestHelpers
@testable import Recipe

@MainActor
final class RecipeEditModalFeature {
    let view: RecipeEditScreenModal
    private var host: (UIWindow, UIViewController)?
    private(set) var onSaveCallCount = 0
    private(set) var onCancelCallCount = 0

    init(view: RecipeEditScreenModal) {
        self.view = view
        view.viewModel.onSaveCompleted = { [weak self] in
            self?.onSaveCallCount += 1
        }
    }

    func start() {
        host = hostInWindow(view)
    }

    func finish() {
        host = nil
    }

    func userTapsSave(sourceLocation: SourceLocation = #_sourceLocation) throws {
        let button = try view.inspect()
            .find(viewWithAccessibilityIdentifier: RecipeEditA11y.saveButton)
            .button()
        try button.tap()
    }

    func ensureIsSaving(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let _ = try self.view.inspect()
                .find(viewWithAccessibilityIdentifier: RecipeEditA11y.savingIndicator)
            return true
        }
    }

    func ensureFormIsDisabled(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let _ = try self.view.inspect()
                .find(viewWithAccessibilityIdentifier: RecipeEditA11y.savingOverlay)
            return true
        }
    }

    func ensureIsDisplayingTitleValidationError(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let _ = try self.view.inspect()
                .find(viewWithAccessibilityIdentifier: HeaderEditViewA11y.errorLabel)
            return true
        }
    }

    func ensureIsDisplayingDescriptionValidationError(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let _ = try self.view.inspect()
                .find(viewWithAccessibilityIdentifier: DescriptionEditViewA11y.errorLabel)
            return true
        }
    }

    func ensureIsDisplayingTextBlockValidationError(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let _ = try self.view.inspect()
                .find(viewWithAccessibilityIdentifier: TextBlockEditViewA11y.textErrorLabel)
            return true
        }
    }

    func ensureIsDisplayingStepTextValidationError(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let _ = try self.view.inspect()
                .find(viewWithAccessibilityIdentifier: RecipeStepEditViewA11y.textErrorLabel)
            return true
        }
    }

    func ensureOnSaveWasCalled(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            (self?.onSaveCallCount ?? 0) > 0
        }
    }

    func ensureOnSaveWasNotCalled(sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard onSaveCallCount == 0 else {
            throw sourceLocation.error("Expected onSave not to be called, but it was called \(onSaveCallCount) time(s)")
        }
    }

    func ensureSaveWasNotAttempted(saver: RecipeEditSaverStub, sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard saver.saveCount == 0 else {
            throw sourceLocation.error("Expected saver not to be called, but it was called \(saver.saveCount) time(s)")
        }
    }
}
#endif
