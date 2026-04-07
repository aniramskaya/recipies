//
//  RecipeListAssembly.swift
//  recipes
//
//  Created by Марина Чемезова on 15.01.2026.
//

public enum RecipeListAssembly {
    @MainActor
    public static func composeWithCalbackServices() -> RecipeListScreen {
        return composeInternalWithCallbackServices(
            dtoLoader: RecipeListDTOLoaderStub(),
            cacheExpirationPolicy: RecipeListExpirationPolicy(timeout: (300))
        ).0
    }
    
    @MainActor
    static func composeInternalWithCallbackServices(
        dtoLoader: RecipeListDTOLoader,
        cacheExpirationPolicy: TimestampExpirationPolicy
    ) -> (RecipeListScreen, [AnyObject]) {
        let (recipeListLoader, leakable) = RecipeListLoaderAssembly.composeInternal(
            dtoLoader: dtoLoader,
            cacheExpirationPolicy: cacheExpirationPolicy
        )
        let asyncLoader = RecipeListLoaderAsyncAdapter(loader: recipeListLoader)
        let viewModel = RecipeListScreenViewModel(loader: asyncLoader)
        let screen = RecipeListScreen(viewModel: viewModel)
        return (screen, leakable + [recipeListLoader, viewModel])
    }
}
