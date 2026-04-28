import Foundation

@MainActor
final class RecipeFormViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var cookingTime: String = ""
    @Published var complexity: Int = 1
    @Published private(set) var errors: RecipeEditFormErrors = .none

    func populate(from data: RecipeData) {
        name = data.name
        cookingTime = String(data.cookingTime)
        complexity = data.complexity
    }

    func save() {
        let nameError: String? = name.isEmpty ? "Поле обязательно" : nil

        let cookingTimeError: String?
        if cookingTime.isEmpty {
            cookingTimeError = "Поле обязательно"
        } else if Int(cookingTime) == nil || Int(cookingTime)! <= 0 {
            cookingTimeError = "Введите корректное число"
        } else {
            cookingTimeError = nil
        }

        errors = RecipeEditFormErrors(name: nameError, cookingTime: cookingTimeError, complexity: nil)

        guard nameError == nil, cookingTimeError == nil else { return }
        print("RecipeEdit: saved name=\(name) cookingTime=\(cookingTime) complexity=\(complexity)")
    }
}
