//
//  RecipeListViewModel.swift
//  recipes
//
//  Created by Марина Чемезова on 14.01.2026.
//

import Foundation

@MainActor
final class RecipeListScreenViewModel: ObservableObject {
    @Published private(set) var state: RecipeListScreenViewState = .loading
    private let loader: RecipeListLoaderAsyncAdapter
    
    init(loader: RecipeListLoaderAsyncAdapter) {
        self.loader = loader
    }
    
    func loadRecipes() async {
        state = .loading
        do {
            let data = try await loader.load()
            state = .data(data.asViewModels())
        } catch {
            state = .error(error)
        }
    }
}
