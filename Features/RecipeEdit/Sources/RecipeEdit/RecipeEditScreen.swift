import SwiftUI
import RecipeUIKit

struct RecipeEditScreen: View {
    @ObservedObject private var loadingViewModel: RecipeLoadingViewModel
    @ObservedObject private var formViewModel: RecipeFormViewModel

    init(loadingViewModel: RecipeLoadingViewModel, formViewModel: RecipeFormViewModel) {
        self.loadingViewModel = loadingViewModel
        self.formViewModel = formViewModel
    }

    var body: some View {
        content
            .task { await loadingViewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch loadingViewModel.state {
        case .idle, .loading:
            LoadingView()
        case .loaded:
            RecipeEditView(
                name: $formViewModel.name,
                cookingTime: $formViewModel.cookingTime,
                complexity: $formViewModel.complexity,
                errors: formViewModel.errors,
                savingState: formViewModel.savingState,
                onSave: formViewModel.save,
                onClose: formViewModel.dismissError
            )
        case .failed(let error):
            ErrorView(error: error.localizedDescription) {
                Task { await loadingViewModel.load() }
            }
        }
    }
}
