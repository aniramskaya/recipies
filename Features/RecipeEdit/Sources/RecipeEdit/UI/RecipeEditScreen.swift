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
    case loaded
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

struct RecipeEditScreen<Content: View>: View {
    @ObservedObject private var recipeEditScreenModel: RecipeEditScreenModel
    @ViewBuilder private var editContent: () -> Content

    init(
        recipeEditScreenModel: RecipeEditScreenModel,
        editContent: @escaping () -> Content
    ) {
        self.recipeEditScreenModel = recipeEditScreenModel
        self.editContent = editContent
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
        case .loaded:
            editContent()
        case .failed(let error):
            ErrorView(error: error.localizedDescription) {
                recipeEditScreenModel.load()
            }
        }
    }
}
