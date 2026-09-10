import Testing
import SwiftUI
import ViewInspector
@testable import Recipe

struct RecipeCookingEditViewTests {
    @MainActor
    @Test("Displays all steps")
    func displaysSteps() throws {
        let steps: [RecipeStepDraftModel] = [
            .init(id: UUID(), title: "Маринование", imageSource: nil, text: "Нарезать и смешать"),
            .init(id: UUID(), title: "Обжарка", imageSource: nil, text: "Жарить 10 минут"),
        ]
        let sut = RecipeCookingEditView(steps: .constant(steps))
        let view = try sut.inspect().find(RecipeCookingEditView.self)
        #expect(throws: Never.self) {
            try view.assertIsDisplaying(steps: [
                (title: "Маринование", text: "Нарезать и смешать"),
                (title: "Обжарка", text: "Жарить 10 минут"),
            ])
        }
    }

    @MainActor
    @Test("Add button appends empty step to model")
    func addButtonAppendsEmptyStep() throws {
        var steps: [RecipeStepDraftModel] = []
        let binding = Binding(get: { steps }, set: { steps = $0 })
        let sut = RecipeCookingEditView(steps: binding)
        let view = try sut.inspect().find(RecipeCookingEditView.self)
        try view.tapAddButton()
        #expect(steps.count == 1)
        #expect(steps[0].title == "")
        #expect(steps[0].text == "")
    }

    @MainActor
    @Test("Deleting first step removes it from model")
    func deletingFirstStepRemovesIt() throws {
        var steps: [RecipeStepDraftModel] = [
            .init(id: UUID(), title: "Первый", imageSource: nil, text: ""),
            .init(id: UUID(), title: "Второй", imageSource: nil, text: ""),
        ]
        let binding = Binding(get: { steps }, set: { steps = $0 })
        let sut = RecipeCookingEditView(steps: binding)
        let view = try sut.inspect().find(RecipeCookingEditView.self)
        try view.deleteStep(at: 0)
        #expect(steps.count == 1)
        #expect(steps[0].title == "Второй")
    }

    @MainActor
    @Test("Deleting last step removes it from model")
    func deletingLastStepRemovesIt() throws {
        var steps: [RecipeStepDraftModel] = [
            .init(id: UUID(), title: "Первый", imageSource: nil, text: ""),
            .init(id: UUID(), title: "Второй", imageSource: nil, text: ""),
        ]
        let binding = Binding(get: { steps }, set: { steps = $0 })
        let sut = RecipeCookingEditView(steps: binding)
        let view = try sut.inspect().find(RecipeCookingEditView.self)
        try view.deleteStep(at: 1)
        #expect(steps.count == 1)
        #expect(steps[0].title == "Первый")
    }

    @MainActor
    @Test("Typing title updates step in model")
    func typingTitleUpdatesModel() throws {
        var steps = [RecipeStepDraftModel(id: UUID(), title: "", imageSource: nil, text: "")]
        let binding = Binding(get: { steps }, set: { steps = $0 })
        let sut = RecipeCookingEditView(steps: binding)
        let view = try sut.inspect().find(RecipeCookingEditView.self)
        try view.typeTitle("Тушение", at: 0)
        #expect(steps[0].title == "Тушение")
    }

    @MainActor
    @Test("Typing text updates step in model")
    func typingTextUpdatesModel() throws {
        var steps = [RecipeStepDraftModel(id: UUID(), title: "", imageSource: nil, text: "")]
        let binding = Binding(get: { steps }, set: { steps = $0 })
        let sut = RecipeCookingEditView(steps: binding)
        let view = try sut.inspect().find(RecipeCookingEditView.self)
        try view.typeText("Добавить воду и тушить 20 минут", at: 0)
        #expect(steps[0].text == "Добавить воду и тушить 20 минут")
    }
}
