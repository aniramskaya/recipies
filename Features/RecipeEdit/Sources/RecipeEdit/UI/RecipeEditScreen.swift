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
    @Published var loadingState: ResourceLoadState<Void> = .loading

    var load: () -> Void = {}
    var onDisappear: () -> Void = {}
}

struct RecipeEditScreen<Content: View>: View {
    @ObservedObject private var model: RecipeEditScreenModel
    @ViewBuilder private var editContent: () -> Content

    init(
        model: RecipeEditScreenModel,
        editContent: @escaping () -> Content
    ) {
        self.model = model
        self.editContent = editContent
    }

    var body: some View {
        ResourceLoadingView(
            state: model.loadingState,
            loading: {
                LoadingView()
            }, failure: { error in
                ErrorView(error: error.localizedDescription) {
                    model.load()
                }
            }, content: { _ in
                editContent()
            }
        )
        .task { model.load() }
        .onDisappear(perform: { model.onDisappear() })
    }
}
