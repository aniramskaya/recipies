//
//  RecipeListScreen.swift
//  RecipeList
//
//  Created by Марина Чемезова on 05.01.2026.
//

import SwiftUI
import RecipeUIKit

struct RecipeListScreen: View {
    var viewModel: RecipeListScreenViewModel
    
    var body: some View {
        content
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case let .loaded(model):
            RecipeListView(
                model: model,
                onSelectItem: { [weak viewModel] id, isDraft in
                    viewModel?.onSelectItem(id, isDraft)
                }
            )
        case .failed:
            ErrorView(error: "Не удалось загрузить список рецептов") { [weak viewModel] in
                viewModel?.onRetry()
            }
        default:
            LoadingView()
        }
    }
}
