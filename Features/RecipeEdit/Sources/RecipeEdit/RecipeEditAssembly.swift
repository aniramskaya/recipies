import Foundation

enum RecipeEditAssembly {
    @MainActor
    static func composeInternal(
        loader: any RecipeLoader,
        recipeId: UUID = UUID()
    ) -> (RecipeEditScreen, [AnyObject]) {
        let viewModel = RecipeEditViewModel(loader: loader, recipeId: recipeId)
        let screen = RecipeEditScreen(viewModel: viewModel)
        return (screen, [viewModel])
    }
}
