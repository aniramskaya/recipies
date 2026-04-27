//
//  RecipeListScreen.swift
//  RecipeList
//
//  Created by Марина Чемезова on 05.01.2026.
//

import SwiftUI
import RecipeUIKit

enum RecipeListScreenViewState {
    case loading
    case error(Error)
    case data([RecipeListRowModel])
}

public struct RecipeListScreen: View {
    @ObservedObject var viewModel: RecipeListScreenViewModel
    let onSelectItem: @MainActor (_: UUID) -> Void
    
    public var body: some View {
        content
            .task {
                await viewModel.loadRecipes()
            }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case let .data(model):
            RecipeListView(
                model: model,
                reload: { [weak viewModel] in
                    await viewModel?.loadRecipes()
                },
                onSelectItem: onSelectItem
            )
        case .error:
            ErrorView(error: "Не удалось загрузить список рецептов") {
                Task { await viewModel.loadRecipes() }
            }
        default:
            LoadingView()
        }
    }
}
