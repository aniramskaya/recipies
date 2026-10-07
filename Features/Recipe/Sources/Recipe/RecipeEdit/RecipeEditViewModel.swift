import Foundation

@MainActor
@Observable
final class RecipeEditViewModel {
    let model: RecipeDraftModel

    var onCancelTapped: () -> Void = {}
    var onSubmitTapped: () -> Void = {}

    var isSaving = false
    var fieldErrors: [String: String] = [:]
    var saveError: Error? = nil
    
    init(model: RecipeDraftModel) {
        self.model = model
    }
}
