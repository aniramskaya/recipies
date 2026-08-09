
import SwiftUI

@MainActor
@Observable
final class RecipeDraftModel {
    var title: String = ""
    var description: String = ""
    var ingredients: [IngredientDraftModel] = [
        .init(id: UUID(), name: ""),
    ]
}
