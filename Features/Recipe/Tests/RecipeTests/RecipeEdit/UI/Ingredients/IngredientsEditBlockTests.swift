import Testing
import SwiftUI
import ViewInspector
import TestHelpers

@testable import Recipe

struct IngredientsEditBlockTests {
    @MainActor
    @Test("Displays all ingredients")
    func displaysIngredients() throws {
        let items: [IngredientDraftModel] = [
            .init(id: UUID(), name: "700 г курицы"),
            .init(id: UUID(), name: "2 зубчика чеснока"),
        ]
        let sut = IngredientsEditBlock(items: .constant(items))
        let view = try sut.inspect().find(IngredientsEditBlock.self)
        #expect(throws: Never.self) {
            try view.assertIsDisplaying(ingredients: ["700 г курицы", "2 зубчика чеснока"])
        }
    }

    @MainActor
    @Test("Typing updates ingredient name in model")
    func typingUpdatesIngredient() throws {
        var items = [IngredientDraftModel(id: UUID(), name: "Старое название")]
        let binding = Binding(get: { items }, set: { items = $0 })
        let sut = IngredientsEditBlock(items: binding)
        let view = try sut.inspect().find(IngredientsEditBlock.self)
        try view.typeIngredient("Новое название", at: 0)
        #expect(items[0].name == "Новое название")
    }

    @MainActor
    @Test("Deleting removes ingredient from model")
    func deletingRemovesIngredient() throws {
        var items: [IngredientDraftModel] = [
            .init(id: UUID(), name: "Первый"),
            .init(id: UUID(), name: "Второй"),
        ]
        let binding = Binding(get: { items }, set: { items = $0 })
        let sut = IngredientsEditBlock(items: binding)
        let view = try sut.inspect().find(IngredientsEditBlock.self)
        try view.deleteIngredient(at: 0)
        #expect(items.count == 1)
        #expect(items[0].name == "Второй")
    }

    @MainActor
    @Test("Add button appends empty ingredient to model")
    func addButtonAppendsEmptyIngredient() throws {
        var items: [IngredientDraftModel] = []
        let binding = Binding(get: { items }, set: { items = $0 })
        let sut = IngredientsEditBlock(items: binding)
        let view = try sut.inspect().find(IngredientsEditBlock.self)
        try view.tapAddButton()
        #expect(items.count == 1)
        #expect(items[0].name == "")
    }
}
