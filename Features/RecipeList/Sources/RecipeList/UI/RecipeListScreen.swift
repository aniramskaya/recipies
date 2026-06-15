//
//  RecipeListScreen.swift
//  RecipeList
//
//  Created by Марина Чемезова on 05.01.2026.
//

import SwiftUI
import RecipeUIKit

public struct RecipeListScreen: View {
    @ObservedObject var viewModel: RecipeListScreenViewModel
    
    public var body: some View {
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
                reload: { [weak viewModel] in
                    viewModel?.onRetry()
                },
                onSelectItem: { [weak viewModel] id in
                    viewModel?.onSelectItem(id)
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
