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

struct RecipeListScreen: View {
    @ObservedObject var viewModel: RecipeListScreenViewModel
    
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
            RecipeListView(model: model) { [weak viewModel] in
                await viewModel?.loadRecipes()
            }
        case .error:
            ErrorView(error: "Не удалось загрузить список рецептов") {
                Task { await viewModel.loadRecipes() }
            }
        default:
            LoadingView()
        }
    }
}
