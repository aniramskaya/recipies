//
//  RecipeDetailScreen.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 21.07.2026.
//

import SwiftUI
import RecipeUIKit

@MainActor
@Observable
final class RecipeDetailScreenModel {
    var loadingState: ResourceLoadState<RecipeDetailViewModel> = .loading

    var onAppear: () -> Void = {}
    var onDisappear: () -> Void = {}
    var onRetry: () -> Void = {}
    var onEdit: () -> Void = {}
}

struct RecipeDetailScreen: View {
    @State private var model: RecipeDetailScreenModel
    
    init(loader: any RecipeDetailLoader, onEdit: @escaping  (RecipeDraftModel, @escaping () -> Void) -> Void) {
        _model = State(wrappedValue: RecipeDetailScreenAssembly.composeModel(
            loader: loader,
            onEdit: onEdit
        ).0)
    }

    var body: some View {
        ResourceLoadingView(
            state: model.loadingState,
            loading: {
                LoadingView()
            },
            failure: { error in
                ErrorView(error: error.localizedDescription) { model.onRetry() }
            },
            content: { viewModel in
                RecipeDetailView(model: viewModel)
            }
        )
        .toolbar {
            if case .loaded = model.loadingState {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(.recipeEdit, action: model.onEdit)
                }
            }
        }
        .onAppear { model.onAppear() }
        .onDisappear { model.onDisappear() }
    }
}
