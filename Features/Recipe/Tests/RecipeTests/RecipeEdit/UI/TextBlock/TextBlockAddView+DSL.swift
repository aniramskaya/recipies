import Testing
import ViewInspector
import TestHelpers
@testable import Recipe

extension InspectableView where View == ViewType.View<TextBlockAddView> {
    @MainActor
    func tapAddButton(sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard let btn = try? self.find(viewWithAccessibilityIdentifier: TextBlockAddViewA11y.addButton).button() else {
            throw sourceLocation.error("TextBlockAddView does not have an add button")
        }
        try btn.tap()
    }
}
