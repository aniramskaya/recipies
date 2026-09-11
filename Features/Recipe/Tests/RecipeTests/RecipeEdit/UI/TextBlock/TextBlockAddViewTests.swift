import Testing
import SwiftUI
import ViewInspector
@testable import Recipe

struct TextBlockAddViewTests {
    @MainActor
    @Test("Add button calls onAdd")
    func addButtonCallsOnAdd() throws {
        var added = false
        let sut = TextBlockAddView(onAdd: { added = true })
        let view = try sut.inspect().find(TextBlockAddView.self)
        try view.tapAddButton()
        #expect(added)
    }
}
