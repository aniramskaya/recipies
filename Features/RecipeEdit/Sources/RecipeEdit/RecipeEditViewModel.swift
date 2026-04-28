import Foundation

enum RecipeLoadingState {
    case idle
    case loading
    case loaded(RecipeData)
    case failed(Error)
}

@MainActor
final class RecipeEditViewModel: ObservableObject {
    @Published private(set) var state: RecipeLoadingState = .idle
    @Published var name: String = ""
    @Published var cookingTime: String = ""
    @Published var complexity: Int = 1
    @Published private(set) var errors: RecipeEditFormErrors = .none

    private let loader: any RecipeLoader

    init(loader: any RecipeLoader) {
        self.loader = loader
    }

    func load() async {
        state = .loading
        do {
            let data = try await loader.load()
            name = data.name
            cookingTime = String(data.cookingTime)
            complexity = data.complexity
            state = .loaded(data)
        } catch {
            state = .failed(error)
        }
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
