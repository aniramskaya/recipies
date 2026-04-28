import Foundation

@MainActor
final class RecipeLoadingViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded
        case failed(Error)
    }

    @Published private(set) var state: State = .idle

    private let loader: any RecipeLoader
    private let onLoaded: (RecipeData) -> Void

    init(loader: any RecipeLoader, onLoaded: @escaping (RecipeData) -> Void) {
        self.loader = loader
        self.onLoaded = onLoaded
    }

    func load() async {
        state = .loading
        do {
            let data = try await loader.load()
            onLoaded(data)
            state = .loaded
        } catch {
            state = .failed(error)
        }
    }
}
