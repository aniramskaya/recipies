import Testing
import ViewInspector
import TestHelpers
@testable import Recipe

extension InspectableView where View == ViewType.View<TextBlockEditView> {
    @MainActor
    func assertIsDisplaying(title: String, text: String, sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard let titleField = try? self.find(viewWithAccessibilityIdentifier: TextBlockEditViewA11y.title).textField() else {
            throw sourceLocation.error("TextBlockEditView does not have a title field")
        }
        guard let titleInput = try? titleField.input() else {
            throw sourceLocation.error("Cannot read title field value")
        }
        guard titleInput == title else {
            throw sourceLocation.error("TextBlockEditView title expected '\(title)', got '\(titleInput)'")
        }

        guard let textField = try? self.find(viewWithAccessibilityIdentifier: TextBlockEditViewA11y.text).textField() else {
            throw sourceLocation.error("TextBlockEditView does not have a text field")
        }
        guard let textInput = try? textField.input() else {
            throw sourceLocation.error("Cannot read text field value")
        }
        guard textInput == text else {
            throw sourceLocation.error("TextBlockEditView text expected '\(text)', got '\(textInput)'")
        }
    }

    @MainActor
    func typeTitle(_ title: String, sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard let tf = try? self.find(viewWithAccessibilityIdentifier: TextBlockEditViewA11y.title).textField() else {
            throw sourceLocation.error("TextBlockEditView does not have a title field")
        }
        try tf.setInput(title)
    }

    @MainActor
    func typeText(_ text: String, sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard let tf = try? self.find(viewWithAccessibilityIdentifier: TextBlockEditViewA11y.text).textField() else {
            throw sourceLocation.error("TextBlockEditView does not have a text field")
        }
        try tf.setInput(text)
    }

    @MainActor
    func tapRemoveButton(sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard let btn = try? self.find(viewWithAccessibilityIdentifier: TextBlockEditViewA11y.removeButton).button() else {
            throw sourceLocation.error("TextBlockEditView does not have a remove button")
        }
        try btn.tap()
    }
}
