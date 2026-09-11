import Testing
import ViewInspector
import TestHelpers
@testable import Recipe

private typealias A11y = RecipeCookingEditViewA11y

extension InspectableView where View == ViewType.View<RecipeCookingEditView> {
    @MainActor
    func assertIsDisplaying(steps: [(title: String, text: String)], sourceLocation: SourceLocation = #_sourceLocation) throws {
        let stepViews = self.findAll(RecipeStepEditView.self)
        guard stepViews.count == steps.count else {
            throw sourceLocation.error("Steps count mismatch: expected \(steps.count), found \(stepViews.count)")
        }
        for (view, expected) in zip(stepViews, steps) {
            try view.assertIsDisplaying(title: expected.title, text: expected.text, sourceLocation: sourceLocation)
        }
    }

    @MainActor
    func typeTitle(_ title: String, at index: Int, sourceLocation: SourceLocation = #_sourceLocation) throws {
        let stepViews = self.findAll(RecipeStepEditView.self)
        guard index < stepViews.count else {
            throw sourceLocation.error("No step at index \(index), found \(stepViews.count) total")
        }
        try stepViews[index].typeTitle(title, sourceLocation: sourceLocation)
    }

    @MainActor
    func typeText(_ text: String, at index: Int, sourceLocation: SourceLocation = #_sourceLocation) throws {
        let stepViews = self.findAll(RecipeStepEditView.self)
        guard index < stepViews.count else {
            throw sourceLocation.error("No step at index \(index), found \(stepViews.count) total")
        }
        try stepViews[index].typeText(text, sourceLocation: sourceLocation)
    }

    @MainActor
    func deleteStep(at index: Int, sourceLocation: SourceLocation = #_sourceLocation) throws {
        let stepViews = self.findAll(RecipeStepEditView.self)
        guard index < stepViews.count else {
            throw sourceLocation.error("No step at index \(index), found \(stepViews.count) total")
        }
        try stepViews[index].tapRemoveButton(sourceLocation: sourceLocation)
    }

    @MainActor
    func tapAddButton(sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard let btn = try? self.find(viewWithAccessibilityIdentifier: A11y.addButton).button() else {
            throw sourceLocation.error("RecipeCookingEditView does not have an add button")
        }
        try btn.tap()
    }
}
