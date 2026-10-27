import SwiftUI
import RecipeUIKit

@MainActor
@Observable
class RecipeCreateScreenViewModel {
    var state: ResourceLoadState<RecipeDraftModel>
    var onAppear: () -> Void = {}
    var onDisappear: () -> Void = {}
    var onRetry: () -> Void = {}
    
    init(state: ResourceLoadState<RecipeDraftModel>) {
        self.state = state
    }
}

struct RecipeCreateScreen: View {
    let viewModel: RecipeCreateScreenViewModel
    let saver: any RecipeSaver
    let deleter: any RecipeDeleter

    var body: some View {
        ResourceLoadingView(
            state: viewModel.state,
            loading: {
                LoadingView()
            },
            failure: { error in
                ErrorView(error: error.localizedDescription) { viewModel.onRetry() }
            },
            content: { viewModel in
                RecipeEditScreenAssembly.composeDraft(
                    model: viewModel,
                    saver: saver,
                    deleter: deleter,
                    onCancel: {},
                    onSaveCompleted: {},
                    onDeleteCompleted: {}
                )
            }
        )
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
    }
}
