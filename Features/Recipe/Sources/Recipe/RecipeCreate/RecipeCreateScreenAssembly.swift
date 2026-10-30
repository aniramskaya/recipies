import SwiftUI
import Scenarios
import RecipeTypes

enum RecipeCreateScreenAssembly {
    @MainActor
    static func composeModel(
        loader: any RecipeDetailLoader
    ) -> RecipeCreateScreenViewModel {
        
        let viewModel = RecipeCreateScreenViewModel(state: .loading)
        let loadingScenario = BasicLoadingScenario(loader: loader.load)

        var loadingTask: Task<Void, Never>? = nil
        let load = { [weak viewModel] in
            loadingTask?.cancel()
            loadingTask = Task { [weak viewModel] in
                let stream = loadingScenario.start()
                for await state in stream {
                    guard let viewModel else { return }
                    setLoadingState(state, viewModel: viewModel)
                }
            }
        }
        
        viewModel.onAppear = load
        viewModel.onRetry = load
        viewModel.onDisappear = {
            loadingTask?.cancel()
        }

        return viewModel
        
        @MainActor
        func setLoadingState(
            _ state: BasicLoadingScenario<Recipe>.State,
            viewModel: RecipeCreateScreenViewModel
        ) {
            switch state {
            case .loading:
                viewModel.state = .loading
            case let .failure(error):
                viewModel.state = .failed(error)
            case let .loaded(recipe):
                viewModel.state = .loaded(recipe.asDraftModel())
            }
        }
    }
}
