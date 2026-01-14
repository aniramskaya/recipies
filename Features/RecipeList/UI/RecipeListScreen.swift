//
//  RecipeListScreen.swift
//  RecipieList
//
//  Created by Марина Чемезова on 05.01.2026.
//

import SwiftUI



enum RecipeListScreenViewState {
    case loading
    case error(Error)
    case data([RecipeListRowModel])
}

@MainActor
final class RecipeListViewModel: ObservableObject {
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



struct RecipeListScreen: View {
    @ObservedObject var viewModel: RecipeListViewModel
    
    var body: some View {
        content
            .task {
                await viewModel.loadRecipes()
            }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case let .data(model):
            RecipeListView(model: model)
        case let .error(error):
            ErrorView(error: "Не удалось загрузить список рецептов") {
                Task { await viewModel.loadRecipes() }
            }
        default:
            LoadingView()
        }
    }
}
