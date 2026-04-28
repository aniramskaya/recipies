import Foundation

enum SavingState: Equatable {
    case idle
    case saving
    case succeeded
    case failed(Error)

    static func == (lhs: SavingState, rhs: SavingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.saving, .saving), (.succeeded, .succeeded): return true
        case (.failed, .failed): return true
        default: return false
        }
    }
}

@MainActor
final class RecipeFormViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var cookingTime: String = ""
    @Published var complexity: Int = 1
    @Published private(set) var errors: RecipeEditFormErrors = .none
    @Published private(set) var savingState: SavingState = .idle

    private let saver: any RecipeSaver

    init(saver: any RecipeSaver) {
        self.saver = saver
    }

    func populate(from data: RecipeData) {
        name = data.name
        cookingTime = String(data.cookingTime)
        complexity = data.complexity
    }

    func save() {
        Task { await performSave() }
    }

    func dismissError() {
        if case .failed = savingState {
            savingState = .idle
        }
    }

    private func performSave() async {
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

        savingState = .saving
        do {
            let data = RecipeData(name: name, cookingTime: Int(cookingTime)!, complexity: complexity)
            try await saver.save(data)
            savingState = .succeeded
            try? await Task.sleep(for: .seconds(2))
            savingState = .idle
        } catch {
            savingState = .failed(error)
        }
    }
}
