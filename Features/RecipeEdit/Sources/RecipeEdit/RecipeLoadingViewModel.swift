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
    var onLoaded: (RecipeData) -> Void = { _ in }

    private let loader: any RecipeLoader

    init(loader: any RecipeLoader) {
        self.loader = loader
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
