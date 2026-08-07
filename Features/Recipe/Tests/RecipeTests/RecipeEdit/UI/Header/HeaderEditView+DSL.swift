import Testing
import ViewInspector
import TestHelpers
@testable import Recipe

extension InspectableView where View == ViewType.View<HeaderEditView> {
    @MainActor
    func assertIsDisplaying(title: String, sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard let tf = try? self.find(ViewType.TextField.self) else {
            throw sourceLocation.error("HeaderEditView does not have a title text field")
        }
        guard let input = try? tf.input() else {
            throw sourceLocation.error("Cannot read title text field value")
        }
        guard input == title else {
            throw sourceLocation.error("HeaderEditView title expected '\(title)', got '\(input)'")
        }
    }

    @MainActor
    func typeTitle(_ text: String, sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard let tf = try? self.find(ViewType.TextField.self) else {
            throw sourceLocation.error("HeaderEditView does not have a title text field")
        }
        try tf.setInput(text)
    }
}
