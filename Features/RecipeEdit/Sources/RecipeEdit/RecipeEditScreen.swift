import SwiftUI
import RecipeUIKit

struct RecipeEditScreen: View {
    @ObservedObject private var viewModel: RecipeEditViewModel

    init(viewModel: RecipeEditViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            LoadingView()
        case .loaded:
            RecipeEditView(
                name: $viewModel.name,
                cookingTime: $viewModel.cookingTime,
                complexity: $viewModel.complexity,
                errors: viewModel.errors,
                onSave: viewModel.save
            )
        case .failed(let error):
            ErrorView(error: error.localizedDescription) {
                Task { await viewModel.load() }
            }
        }
    }
}
