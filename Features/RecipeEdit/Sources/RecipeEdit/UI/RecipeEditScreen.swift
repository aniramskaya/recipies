//
//  RecipeEditScenarionScreen.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.05.2026.
//

import SwiftUI
import RecipeUIKit

@MainActor
final class RecipeEditScreenModel: ObservableObject {
    @Published var loadingState: ResourceLoadState<Void> = .loading

    var load: () -> Void = {}
    var onDisappear: () -> Void = {}
}

struct RecipeEditScreen<Content: View>: View {
    @ObservedObject private var model: RecipeEditScreenModel
    @ViewBuilder private var editView: () -> Content

    init(
        model: RecipeEditScreenModel,
        editContent: @escaping () -> Content
    ) {
        self.model = model
        self.editView = editContent
    }

    var body: some View {
        ResourceLoadingView(
            state: model.loadingState,
            loading: {
                LoadingView()
            },
            failure: { error in
                ErrorView(error: error.localizedDescription) { model.load() }
            },
            content: { _ in
                editView()
            }
        )
        .task { model.load() }
        .onDisappear(perform: { model.onDisappear() })
    }
}
