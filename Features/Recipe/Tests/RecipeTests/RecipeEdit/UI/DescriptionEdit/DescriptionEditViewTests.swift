import Testing
import SwiftUI
import ViewInspector
@testable import Recipe

struct DescriptionEditViewTests {
    @MainActor
    @Test("Displays bound text value")
    func displaysText() throws {
        let sut = DescriptionEditView(text: .constant("Нежные кусочки курицы"))
        let view = try sut.inspect().find(DescriptionEditView.self)
        #expect(throws: Never.self) {
            try view.assertIsDisplaying(text: "Нежные кусочки курицы")
        }
    }

    @MainActor
    @Test("Typing updates binding")
    func typingUpdatesBinding() throws {
        var capturedText = ""
        let binding = Binding(get: { capturedText }, set: { capturedText = $0 })
        let sut = DescriptionEditView(text: binding)
        let view = try sut.inspect().find(DescriptionEditView.self)
        try view.typeText("Новый текст")
        #expect(capturedText == "Новый текст")
    }
}
