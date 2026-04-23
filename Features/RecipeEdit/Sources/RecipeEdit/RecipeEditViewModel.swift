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

    init(loader: any RecipeLoader) {
        self.loader = loader
    }

    func load() async {
        state = .loading
        do {
            let data = try await loader.load()
            state = .loaded(data)
        } catch {
            state = .failed(error)
        }
    }
}
