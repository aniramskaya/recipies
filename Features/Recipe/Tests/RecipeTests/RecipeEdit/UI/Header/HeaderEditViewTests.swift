import Testing
import SwiftUI
import ViewInspector
@testable import Recipe

struct HeaderEditViewTests {
    @MainActor
    @Test("Displays bound title value")
    func displaysTitle() throws {
        let sut = HeaderEditView(value: .constant("Tikka Masala"))
        let view = try sut.inspect().find(HeaderEditView.self)
        #expect(throws: Never.self) {
            try view.assertIsDisplaying(title: "Tikka Masala")
        }
    }

    @MainActor
    @Test("Displays empty title")
    func displaysEmptyTitle() throws {
        let sut = HeaderEditView(value: .constant(""))
        let view = try sut.inspect().find(HeaderEditView.self)
        #expect(throws: Never.self) {
            try view.assertIsDisplaying(title: "")
        }
    }

    @MainActor
    @Test("Updates binding when user types")
    func updatesBindingOnInput() throws {
        var capturedValue = ""
        let binding = Binding(get: { capturedValue }, set: { capturedValue = $0 })
        let sut = HeaderEditView(value: binding)
        let view = try sut.inspect().find(HeaderEditView.self)
        try view.typeTitle("Chicken Tikka")
        #expect(capturedValue == "Chicken Tikka")
    }
}
