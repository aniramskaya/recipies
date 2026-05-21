//
//  RecipeEditScenarionScreen.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.05.2026.
//

import SwiftUI
import RecipeUIKit


enum RecipeLoadState {
    case idle
    case loading
    case failed(Error)
    case loaded(RecipeDataModel)
}
enum RecipeEditState {
    case idle
    case saving
    case savingFailed(Error)
    case saved
}

@MainActor
final class RecipeEditScreenModel: ObservableObject {
    @Published var loadingState: RecipeLoadState = .idle

    var load: () -> Void = {}
    var onDisappear: () -> Void = {}
}

struct RecipeEditScreen: View {
    @ObservedObject private var recipeEditScreenModel: RecipeEditScreenModel
    @ObservedObject private var recipeEditDataModel: RecipeDataModel
    @ObservedObject private var recipeEditViewModel: RecipeEditViewModel

    init(
        recipeEditScreenModel: RecipeEditScreenModel,
        recipeEditDataModel: RecipeDataModel,
        recipeEditViewModel: RecipeEditViewModel
    ) {
        self.recipeEditScreenModel = recipeEditScreenModel
        self.recipeEditDataModel = recipeEditDataModel
        self.recipeEditViewModel = recipeEditViewModel
    }

    var body: some View {
        content
            .task { recipeEditScreenModel.load() }
            .onDisappear(perform: { recipeEditScreenModel.onDisappear() })
    }

    @ViewBuilder
    private var content: some View {
        switch recipeEditScreenModel.loadingState {
        case .idle, .loading:
            LoadingView()
        case let .loaded(model):
            RecipeEditView(
                dataModel: recipeEditDataModel,
                viewModel: recipeEditViewModel
            )
        case .failed(let error):
            ErrorView(error: error.localizedDescription) {
                recipeEditScreenModel.load()
            }
        }
    }
}
