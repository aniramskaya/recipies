
import SwiftUI

@MainActor
@Observable
public final class RecipeDraftModel: Hashable {
    let id: UUID
    var title: String = ""
    var description: String = ""
    var ingredients: [IngredientDraftModel] = [
        .init(id: UUID(), name: ""),
    ]
    
    init(id: UUID, title: String, description: String, ingredients: [IngredientDraftModel]) {
        self.id = id
        self.title = title
        self.description = description
        self.ingredients = ingredients
    }
    
    nonisolated public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    nonisolated public static func ==(lhs: RecipeDraftModel, rhs: RecipeDraftModel) -> Bool {
        lhs.id == rhs.id
    }
}
