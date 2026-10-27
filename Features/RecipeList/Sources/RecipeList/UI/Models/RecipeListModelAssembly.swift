//
//  RecipeListAssembly.swift
//  recipes
//
//  Created by Марина Чемезова on 15.01.2026.
//

import SwiftUI
import Foundation
import Scenarios

enum RecipeListModelAssembly {
    @MainActor
    static func composeModel(
        loader: RecipeListLoader,
    ) -> RecipeListScreenViewModel {
        let viewModel = RecipeListScreenViewModel()

        let loadingScenario = BasicLoadingScenario(
            loader: { try await loader.load() }
        )
        
        var loadingTask: Task<Void, Never>? = nil
        
        let load = { [weak viewModel] in
            loadingTask?.cancel()
            loadingTask = Task { [weak viewModel] in
                let stream = loadingScenario.start()
                for await state in stream {
                    guard let viewModel else { return }
                    setViewModelState(viewModel: viewModel, state)
                }
            }
        }
        
        viewModel.onAppear = load
        viewModel.onRetry = load
        viewModel.onDisappear = { loadingTask?.cancel() }
        
        return viewModel
    }
    
    @MainActor
    private static func setViewModelState(
        viewModel: RecipeListScreenViewModel,
        _ state: BasicLoadingScenario<[RecipeListItem]>.State
    ) {
        switch state {
            case .loading: viewModel.state = .loading
            case let .failure(error): viewModel.state = .failed(error)
            case let .loaded(data): viewModel.state = .loaded(data.asViewModels())
        }
    }
}
