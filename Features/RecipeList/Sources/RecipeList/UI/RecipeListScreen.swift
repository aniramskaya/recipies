//
//  RecipeListScreen.swift
//  RecipeList
//
//  Created by Марина Чемезова on 05.01.2026.
//

import SwiftUI
import RecipeUIKit

public struct RecipeListScreen: View {
    private let onSelectItem: @MainActor (_ id: UUID, _ isDraft: Bool) -> Void

    @State private var viewModel: RecipeListScreenViewModel
    
    public init(
        loader: RecipeListLoader,
        onSelectItem: @MainActor @escaping (_: UUID, _: Bool) -> Void
    ) {
        _viewModel = State(wrappedValue: RecipeListModelAssembly.composeModel(loader: loader))
        self.onSelectItem = onSelectItem
    }

    init(
        viewModel: RecipeListScreenViewModel,
        onSelectItem: @MainActor @escaping (_: UUID, _: Bool) -> Void
    ) {
        _viewModel = State(wrappedValue: viewModel)
        self.onSelectItem = onSelectItem
    }
    
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
                onSelectItem: onSelectItem
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
