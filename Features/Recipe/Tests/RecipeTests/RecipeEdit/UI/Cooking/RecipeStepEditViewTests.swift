import Testing
import SwiftUI
import ViewInspector
@testable import Recipe

struct RecipeStepEditViewTests {
    @MainActor
    @Test("Displays bound title and text values")
    func displaysValues() throws {
        let sut = RecipeStepEditView(
            step: 1,
            model: .constant(RecipeStepDraftModel(id: UUID(), title: "Маринование", imageSource: nil, text: "Нарезать и смешать")),
            onRemove: {}
        )
        let view = try sut.inspect().find(RecipeStepEditView.self)
        #expect(throws: Never.self) {
            try view.assertIsDisplaying(title: "Маринование", text: "Нарезать и смешать")
        }
    }

    @MainActor
    @Test("Typing updates title in binding")
    func typingUpdatesTitleBinding() throws {
        var model = RecipeStepDraftModel(id: UUID(), title: "", imageSource: nil, text: "")
        let binding = Binding(get: { model }, set: { model = $0 })
        let sut = RecipeStepEditView(step: 1, model: binding, onRemove: {})
        let view = try sut.inspect().find(RecipeStepEditView.self)
        try view.typeTitle("Обжарка")
        #expect(model.title == "Обжарка")
    }

    @MainActor
    @Test("Typing updates text in binding")
    func typingUpdatesTextBinding() throws {
        var model = RecipeStepDraftModel(id: UUID(), title: "", imageSource: nil, text: "")
        let binding = Binding(get: { model }, set: { model = $0 })
        let sut = RecipeStepEditView(step: 1, model: binding, onRemove: {})
        let view = try sut.inspect().find(RecipeStepEditView.self)
        try view.typeText("Обжарить на сковороде до золотистой корочки")
        #expect(model.text == "Обжарить на сковороде до золотистой корочки")
    }

    @MainActor
    @Test("Remove button calls onRemove")
    func removeButtonCallsOnRemove() throws {
        var removed = false
        let sut = RecipeStepEditView(
            step: 1,
            model: .constant(RecipeStepDraftModel(id: UUID(), title: "", imageSource: nil, text: "")),
            onRemove: { removed = true }
        )
        let view = try sut.inspect().find(RecipeStepEditView.self)
        try view.tapRemoveButton()
        #expect(removed)
    }
}
