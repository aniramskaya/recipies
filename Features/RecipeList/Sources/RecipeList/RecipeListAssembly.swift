//
//  RecipeListAssembly.swift
//  recipes
//
//  Created by Марина Чемезова on 15.01.2026.
//

import Foundation
import Scenarios

public enum RecipeListAssembly {
//    @MainActor
//    public static func composeWithCalbackServices() -> RecipeListScreen {
//        return composeInternalWithCallbackServices(
//            dtoLoader: RecipeListDTOLoaderStub(),
//            cacheExpirationPolicy: RecipeListExpirationPolicy(timeout: (300)),
//        ).0
//    }
//    
//    @MainActor
//    static func composeInternalWithCallbackServices(
//        dtoLoader: RecipeListDTOLoader,
//        cacheExpirationPolicy: TimestampExpirationPolicy,
//    ) -> (RecipeListScreen, [AnyObject]) {
//        let (recipeListLoader, leakable) = RecipeListLoaderAssembly.composeInternal(
//            dtoLoader: dtoLoader,
//            cacheExpirationPolicy: cacheExpirationPolicy
//        )
//        let asyncLoader = RecipeListLoaderAsyncAdapter(loader: recipeListLoader)
//        let viewModel = RecipeListScreenViewModel(loader: asyncLoader)
//        let screen = RecipeListScreen(viewModel: viewModel, onSelectItem: { _ in })
//        return (screen, leakable + [recipeListLoader, viewModel])
//    }
//    
//    @MainActor
//    public static func composeWithCombineServices() -> RecipeListScreen {
//        return composeInternalWithCombineServices(
//            dtoLoader: RecipeListDTOPublisherStub(),
//            cacheExpirationPolicy: RecipeListExpirationPolicy(timeout: (300))
//        ).0
//    }
//    
//    @MainActor
//    static func composeInternalWithCombineServices(
//        dtoLoader: RecipeListDTOPublisher,
//        cacheExpirationPolicy: TimestampExpirationPolicy
//    ) -> (RecipeListScreen, [AnyObject]) {
//        let (recipeListLoader, leakable) = CombineRecipeListLoaderAssembly.composeInternal(
//            dtoLoader: dtoLoader,
//            cacheExpirationPolicy: cacheExpirationPolicy
//        )
//        let viewModel = RecipeListScreenViewModel(loader: recipeListLoader)
//        let screen = RecipeListScreen(viewModel: viewModel, onSelectItem: { _ in })
//        return (screen, leakable + [viewModel])
//    }
    
    @MainActor
    public static func composeWithAsyncServices(
        onSelectItem: @escaping @MainActor (_: UUID) -> Void
    ) -> RecipeListScreen {
        return composeInternalWithAsyncServices(
            dtoLoader: AsyncRecipeListDTOLoaderStub(),
            cacheExpirationPolicy: RecipeListExpirationPolicy(timeout: (300)),
            onSelectItem: onSelectItem
        ).0
    }
    
    @MainActor
    static func composeInternalWithAsyncServices(
        dtoLoader: AsyncRecipeListDTOLoader,
        cacheExpirationPolicy: TimestampExpirationPolicy,
        onSelectItem: @escaping @MainActor (_: UUID) -> Void
    ) -> (RecipeListScreen, [AnyObject]) {
        let (recipeListLoader, leakable) = AsyncRecipeListLoaderAssembly.composeInternal(
            dtoLoader: dtoLoader,
            cacheExpirationPolicy: cacheExpirationPolicy
        )
        let viewModel = RecipeListScreenViewModel()
        
        let loadingScenario = BasicLoadingScenario(loader: recipeListLoader.load)
        
        var loadingTask: Task<Void, Never>? = nil
        
        let load = { [weak viewModel] in
            loadingTask?.cancel()
            loadingTask = Task { [weak viewModel] in
                let stream = loadingScenario.start()
                for await state in stream {
                    guard let viewModel else { return }
                    switch state {
                    case .loading:
                        viewModel.state = .loading
                    case let .failure(error):
                        viewModel.state = .failed(error)
                    case let .loaded(data):
                        viewModel.state = .loaded(data.asViewModels())
                    }
                }
            }
            
        }
        
        viewModel.onAppear = load
        viewModel.onRetry = load
        viewModel.onDisappear = { loadingTask?.cancel() }
        viewModel.onSelectItem = onSelectItem
        
        let screen = RecipeListScreen(viewModel: viewModel)
        return (screen, leakable + [viewModel])
    }
}
