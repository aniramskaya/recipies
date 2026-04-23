import Foundation

enum RecipeEditAssembly {
    @MainActor
    static func composeInternal(
        loader: any RecipeLoader
    ) -> (RecipeEditScreen, [AnyObject]) {
        let viewModel = RecipeEditViewModel(loader: loader)
        let screen = RecipeEditScreen(viewModel: viewModel)
        return (screen, [viewModel])
    }
}
