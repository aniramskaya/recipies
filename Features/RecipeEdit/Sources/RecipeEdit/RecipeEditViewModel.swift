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

    private let loader: any RecipeLoader
    private let recipeId: UUID

    init(loader: any RecipeLoader, recipeId: UUID) {
        self.loader = loader
        self.recipeId = recipeId
    }

    func load() async {
        if case .loading = state { return }
        state = .loading
        do {
            let data = try await loader.load(id: recipeId)
            state = .loaded(data)
        } catch {
            state = .failed(error)
        }
    }
}
