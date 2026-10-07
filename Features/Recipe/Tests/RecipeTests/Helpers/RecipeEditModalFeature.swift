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
    private(set) var onCancelCallCount = 0

    init(view: RecipeEditScreenModal) {
        self.view = view
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

    func ensureIsDisplayingTitleValidationError(_ text: String, sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            let view = try self?.view.inspect().find(HeaderEditView.self)
            try view?.assertIsDisplayingValidationError(text)
            return true
        }
    }

    func ensureIsDisplayingDescriptionValidationError(_ text: String, sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            let view = try self?.view.inspect().find(DescriptionEditView.self)
            try view?.assertIsDisplayingValidationError(text)
            return true
        }
    }

    func ensureIsDisplayingTextBlockValidationError(_ text: String, at index: Int, sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let views = try self?.view.inspect().findAll(TextBlockEditView.self) else {
                throw sourceLocation.error("Failed to find any TextBlockEditView")
            }
            guard views.indices.contains(index) else {
                throw sourceLocation.error("Failed to find TextBlockEditView at \(index)")
            }
            try views[index].assertIsDisplayingTextValidationError(text)
            return true
        }
    }

    func ensureIsDisplayingStepTextValidationError(_ text: String, at index: Int, sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let views = try self?.view.inspect().findAll(RecipeStepEditView.self) else {
                throw sourceLocation.error("Failed to find any RecipeStepEditView")
            }
            guard views.indices.contains(index) else {
                throw sourceLocation.error("Failed to find RecipeStepEditView at \(index)")
            }
            try views[index].assertIsDisplayingTextValidationError(text)
            return true
        }
    }

    func ensureSaveWasNotAttempted(saver: RecipeEditSaverStub, sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard saver.saveCount == 0 else {
            throw sourceLocation.error("Expected saver not to be called, but it was called \(saver.saveCount) time(s)")
        }
    }
}
#endif
