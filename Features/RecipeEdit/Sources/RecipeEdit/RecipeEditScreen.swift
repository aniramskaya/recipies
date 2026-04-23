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
        case .loaded(let data):
            RecipeEditView(
                data: RecipeEditFormData(
                    name: data.name,
                    cookingTime: String(data.cookingTime),
                    complexity: data.complexity
                ),
                errors: .none,
                onSave: {}
            )
        case .failed(let error):
            ErrorView(error: error.localizedDescription) {
                Task { await viewModel.load() }
            }
        }
    }
}
