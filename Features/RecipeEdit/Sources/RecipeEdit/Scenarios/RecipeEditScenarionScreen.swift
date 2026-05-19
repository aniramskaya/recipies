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
    let load: () -> Void
    let save: () -> Void
    var onDisappear: () -> Void
    
    init(load: @escaping () -> Void, save: @escaping () -> Void, onDisappear: @escaping () -> Void) {
        self.load = load
        self.save = save
        self.onDisappear = onDisappear
    }
}

struct RecipeEditScenarioScreen: View {
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
            RecipeEditScenarioView(
                model: model,
                errors: recipeEditViewModel.errors,
                savingState: recipeEditViewModel.savingState,
                onSave: recipeEditViewModel.save,
                onClose: {}
            )
        case .failed(let error):
            ErrorView(error: error.localizedDescription) {
                recipeEditViewModel.load()
            }
        }
    }
}
