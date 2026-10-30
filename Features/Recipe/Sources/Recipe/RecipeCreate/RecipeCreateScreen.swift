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

public struct RecipeCreateScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: RecipeCreateScreenViewModel
    
    private let saver: any RecipeSaver
    private let deleter: any RecipeDeleter
    
    public init(loader: any RecipeDetailLoader, saver: any RecipeSaver, deleter: any RecipeDeleter) {
        _viewModel = State(wrappedValue: RecipeCreateScreenAssembly.composeModel(loader: loader))
        self.saver = saver
        self.deleter = deleter
    }

    init(viewModel: RecipeCreateScreenViewModel, saver: any RecipeSaver, deleter: any RecipeDeleter) {
        _viewModel = State(wrappedValue: viewModel)
        self.saver = saver
        self.deleter = deleter
    }

    public var body: some View {
        ResourceLoadingView(
            state: viewModel.state,
            loading: {
                LoadingView()
            },
            failure: { error in
                ErrorView(error: error.localizedDescription) { viewModel.onRetry() }
            },
            content: { viewModel in
                RecipeEditScreen(
                    draft: viewModel,
                    saver: saver,
                    deleter: deleter,
                    onCancel: {},
                    onSaveCompleted: {
                        dismiss()
                    },
                    onDeleteCompleted: {
                        dismiss()
                    }
                )
            }
        )
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}
