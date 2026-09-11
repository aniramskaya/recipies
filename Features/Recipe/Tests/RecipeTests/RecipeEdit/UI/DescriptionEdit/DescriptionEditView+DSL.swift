import Testing
import ViewInspector
import TestHelpers
@testable import Recipe

extension InspectableView where View == ViewType.View<DescriptionEditView> {
    @MainActor
    func assertIsDisplaying(text: String, sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard let tf = try? self.find(viewWithAccessibilityIdentifier: DescriptionEditViewA11y.field).textField() else {
            throw sourceLocation.error("DescriptionEditView does not have a text field")
        }
        guard let input = try? tf.input() else {
            throw sourceLocation.error("Cannot read text field value")
        }
        guard input == text else {
            throw sourceLocation.error("DescriptionEditView text expected '\(text)', got '\(input)'")
        }
    }

    @MainActor
    func typeText(_ text: String, sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard let tf = try? self.find(viewWithAccessibilityIdentifier: DescriptionEditViewA11y.field).textField() else {
            throw sourceLocation.error("DescriptionEditView does not have a text field")
        }
        try tf.setInput(text)
    }
}
