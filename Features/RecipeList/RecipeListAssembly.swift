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
    
    @MainActor
    public static func composeWithCombineServices() -> RecipeListScreen {
        return composeInternalWithCombineServices(
            dtoLoader: RecipeListDTOPublisherStub(),
            cacheExpirationPolicy: RecipeListExpirationPolicy(timeout: (300))
        ).0
    }
    
    @MainActor
    static func composeInternalWithCombineServices(
        dtoLoader: RecipeListDTOPublisher,
        cacheExpirationPolicy: TimestampExpirationPolicy
    ) -> (RecipeListScreen, [AnyObject]) {
        let (recipeListLoader, leakable) = CombineRecipeListLoaderAssembly.composeInternal(
            dtoLoader: dtoLoader,
            cacheExpirationPolicy: cacheExpirationPolicy
        )
        let viewModel = RecipeListScreenViewModel(loader: recipeListLoader)
        let screen = RecipeListScreen(viewModel: viewModel)
        return (screen, leakable + [viewModel])
    }
}
