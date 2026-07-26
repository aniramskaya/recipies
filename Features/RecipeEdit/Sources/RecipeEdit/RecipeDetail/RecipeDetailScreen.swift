//
//  RecipeDetailScreen.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 21.07.2026.
//

import SwiftUI
import RecipeUIKit

@MainActor
final class RecipeDetailScreenModel: ObservableObject {
    @Published var loadingState: ResourceLoadState<RecipeDetailViewModel> = .loading

    var onAppear: () -> Void = {}
    var onDisappear: () -> Void = {}
    var onRetry: () -> Void = {}
}

public struct RecipeDetailScreen: View {
    @ObservedObject private var model: RecipeDetailScreenModel

    init(model: RecipeDetailScreenModel) {
        self.model = model
    }

    public var body: some View {
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
        .onAppear { model.onAppear() }
        .onDisappear { model.onDisappear() }
    }
}
