import Testing
import ViewInspector
import TestHelpers
@testable import Recipe

private typealias A11y = IngredientsEditBlockA11y

extension InspectableView where View == ViewType.View<IngredientsEditBlock> {
    @MainActor
    func assertIsDisplaying(ingredients: [String], sourceLocation: SourceLocation = #_sourceLocation) throws {
        let foundItems = self.findAll(IngredientEditView<DragHandleView>.self)
        guard foundItems.count == ingredients.count else {
            throw sourceLocation.error("Ingredients count mismatch: expected \(ingredients.count), found \(foundItems.count)")
        }
        for (view, expectedName) in zip(foundItems, ingredients) {
            guard let tf = try? view.find(ViewType.TextField.self),
                  let input = try? tf.input() else {
                throw sourceLocation.error("Ingredient view is missing a text field")
            }
            guard input == expectedName else {
                throw sourceLocation.error("Ingredient name expected '\(expectedName)', got '\(input)'")
            }
        }
    }

    @MainActor
    func typeIngredient(_ text: String, at index: Int, sourceLocation: SourceLocation = #_sourceLocation) throws {
        let editViews = self.findAll(IngredientEditView<DragHandleView>.self)
        guard index < editViews.count else {
            throw sourceLocation.error("No ingredient at index \(index), found \(editViews.count) total")
        }
        guard let tf = try? editViews[index].find(ViewType.TextField.self) else {
            throw sourceLocation.error("Ingredient at index \(index) has no text field")
        }
        try tf.setInput(text)
    }

    @MainActor
    func deleteIngredient(at index: Int, sourceLocation: SourceLocation = #_sourceLocation) throws {
        let editViews = self.findAll(IngredientEditView<DragHandleView>.self)
        guard index < editViews.count else {
            throw sourceLocation.error("No ingredient at index \(index), found \(editViews.count) total")
        }
        guard let btn = try? editViews[index].find(ViewType.Button.self) else {
            throw sourceLocation.error("Ingredient at index \(index) has no delete button")
        }
        try btn.tap()
    }

    @MainActor
    func tapAddButton(sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard let btn = try? self.find(viewWithAccessibilityIdentifier: A11y.addButton).button() else {
            throw sourceLocation.error("IngredientsEditBlock does not have an add button")
        }
        try btn.tap()
    }
}
