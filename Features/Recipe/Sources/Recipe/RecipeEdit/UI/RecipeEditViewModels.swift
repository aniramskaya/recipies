
import SwiftUI

@MainActor
@Observable
final class RecipeDraftModel {
    var title: String = ""
    var ingredients: [IngredientDraftModel] = [
        .init(id: UUID(), name: "850 г. куриного филе"),
        .init(id: UUID(), name: "200 г. панировочных сухарей"),
    ]
}
