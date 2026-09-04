import Testing
import SwiftUI
import ViewInspector
@testable import Recipe

struct TextBlockEditViewTests {
    @MainActor
    @Test("Displays bound title and text values")
    func displaysValues() throws {
        let sut = TextBlockEditView(
            model: .constant(TextBlockDraftModel(title: "Соус", text: "Смешать все ингредиенты")),
            onRemove: {}
        )
        let view = try sut.inspect().find(TextBlockEditView.self)
        #expect(throws: Never.self) {
            try view.assertIsDisplaying(title: "Соус", text: "Смешать все ингредиенты")
        }
    }

    @MainActor
    @Test("Typing updates title in binding")
    func typingUpdatesTitleBinding() throws {
        var model = TextBlockDraftModel(title: "", text: "")
        let binding = Binding(get: { model }, set: { model = $0 })
        let sut = TextBlockEditView(model: binding, onRemove: {})
        let view = try sut.inspect().find(TextBlockEditView.self)
        try view.typeTitle("Маринад")
        #expect(model.title == "Маринад")
    }

    @MainActor
    @Test("Typing updates text in binding")
    func typingUpdatesTextBinding() throws {
        var model = TextBlockDraftModel(title: "", text: "")
        let binding = Binding(get: { model }, set: { model = $0 })
        let sut = TextBlockEditView(model: binding, onRemove: {})
        let view = try sut.inspect().find(TextBlockEditView.self)
        try view.typeText("Залить курицу и оставить на ночь")
        #expect(model.text == "Залить курицу и оставить на ночь")
    }

    @MainActor
    @Test("Remove button calls onRemove")
    func removeButtonCallsOnRemove() throws {
        var removed = false
        let sut = TextBlockEditView(
            model: .constant(TextBlockDraftModel(title: "", text: "")),
            onRemove: { removed = true }
        )
        let view = try sut.inspect().find(TextBlockEditView.self)
        try view.tapRemoveButton()
        #expect(removed)
    }
}
