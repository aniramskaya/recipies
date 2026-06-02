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
    @Published var loadingState: ResourceLoadState<RecipeDataModel> = .loading

    var onAppear: () -> Void = {}
    var onDisappear: () -> Void = {}
    var onRetry: () -> Void = {}
}

struct RecipeEditScreen<Content: View>: View {
    @ObservedObject private var model: RecipeEditScreenModel
    @ViewBuilder private var editView: (_: RecipeDataModel) -> Content

    init(
        model: RecipeEditScreenModel,
        editContent: @escaping (_: RecipeDataModel) -> Content
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
                ErrorView(error: error.localizedDescription) { model.onRetry() }
            },
            content: { model in
                editView(model)
            }
        )
        .onAppear(perform: { model.onAppear() })
        .onDisappear(perform: { model.onDisappear() })
    }
}
