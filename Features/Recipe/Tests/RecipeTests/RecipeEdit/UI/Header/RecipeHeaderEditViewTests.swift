import Testing
import SwiftUI
import ViewInspector
@testable import Recipe

struct RecipeHeaderEditViewTests {
    @MainActor
    @Test("Displays bound title value")
    func displaysTitle() throws {
        let sut = RecipeHeaderEditView(value: .constant("Tikka Masala"))
        let view = try sut.inspect().find(RecipeHeaderEditView.self)
        #expect(throws: Never.self) {
            try view.assertIsDisplaying(title: "Tikka Masala")
        }
    }

    @MainActor
    @Test("Displays empty title")
    func displaysEmptyTitle() throws {
        let sut = RecipeHeaderEditView(value: .constant(""))
        let view = try sut.inspect().find(RecipeHeaderEditView.self)
        #expect(throws: Never.self) {
            try view.assertIsDisplaying(title: "")
        }
    }

    @MainActor
    @Test("Updates binding when user types")
    func updatesBindingOnInput() throws {
        var capturedValue = ""
        let binding = Binding(get: { capturedValue }, set: { capturedValue = $0 })
        let sut = RecipeHeaderEditView(value: binding)
        let view = try sut.inspect().find(RecipeHeaderEditView.self)
        try view.typeTitle("Chicken Tikka")
        #expect(capturedValue == "Chicken Tikka")
    }
}
