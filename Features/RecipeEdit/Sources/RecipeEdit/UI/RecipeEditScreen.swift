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
    case loaded(RecipeEditModel)
}
enum RecipeEditState {
    case idle
    case saving
    case savingFailed(Error)
    case saved
}

@MainActor
final class RecipeEditViewModel: ObservableObject {
    @Published var loadingState: RecipeLoadState = .idle
    @Published var savingState: SavingState = .idle

    @Published var errors: RecipeEditFormErrors = .none
    
    // Actions
    var load: () -> Void = {}
    var save: () -> Void = {}
    var onCloseError: () -> Void = {}
    var onDisappear: () -> Void = {}
}

struct RecipeEditScreen: View {
    @ObservedObject private var recipeEditViewModel: RecipeEditViewModel

    init(recipeEditViewModel: RecipeEditViewModel) {
        self.recipeEditViewModel = recipeEditViewModel
    }

    var body: some View {
        content
            .task { recipeEditViewModel.load() }
            .onDisappear(perform: { recipeEditViewModel.onDisappear() })
    }

    @ViewBuilder
    private var content: some View {
        switch recipeEditViewModel.loadingState {
        case .idle, .loading:
            LoadingView()
        case let .loaded(model):
            RecipeEditView(
                model: model,
                errors: recipeEditViewModel.errors,
                savingState: recipeEditViewModel.savingState,
                onSave: recipeEditViewModel.save,
                onClose: recipeEditViewModel.onCloseError
            )
        case .failed(let error):
            ErrorView(error: error.localizedDescription) {
                recipeEditViewModel.load()
            }
        }
    }
}
