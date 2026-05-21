
import SwiftUI

@MainActor
final class RecipeDataModel: ObservableObject {
    @Published var name: String = ""
    @Published var cookingTime: String = ""
    @Published var complexity: Int = 1
}

final class RecipeEditViewModel: ObservableObject {
    @Published var errors: RecipeEditFormErrors = .none
    @Published var savingState: SavingState = .idle
    
    var onSave: () -> Void = {}
    var onClose: () -> Void = {}
}

struct RecipeEditFormErrors {
    let name: String?
    let cookingTime: String?
    let complexity: String?
}

extension RecipeEditFormErrors {
    static let none = RecipeEditFormErrors(name: nil, cookingTime: nil, complexity: nil)
}

enum SavingState {
    case idle
    case saving
    case succeeded
    case failed(Error)
}

extension SavingState: Equatable {
    static func == (lhs: SavingState, rhs: SavingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.saving, .saving), (.succeeded, .succeeded): return true
        case (.failed, .failed): return true
        default: return false
        }
    }
}
