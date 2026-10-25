import SwiftUI
import Scenarios
import RecipeTypes

public enum RecipeCreateScreenAssembly {
    @MainActor
    public static func compose(
        saver: any RecipeSaver,
        deleter: any RecipeDeleter,
        onComplete: @escaping () -> Void
    ) -> some View {
        RecipeCreateCoordinator(saver: saver, deleter: deleter, onComplete: onComplete)
    }
}

@MainActor
private struct RecipeCreateCoordinator: View {
    let saver: any RecipeSaver
    let deleter: any RecipeDeleter
    let onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: RecipeEditViewModel
    @State private var savingTask: Task<Void, Never>?
    @State private var didComplete = false

    init(saver: any RecipeSaver, deleter: any RecipeDeleter, onComplete: @escaping () -> Void) {
        self.saver = saver
        self.deleter = deleter
        self.onComplete = onComplete
        self._viewModel = State(wrappedValue: RecipeEditViewModel(model: .newDraft))
    }

    var body: some View {
        RecipeCreateScreen(viewModel: viewModel, onDeleteTapped: handleDelete)
            .task {
                try? await saver.save(viewModel.model.toRecipe(isDraft: true))
                await runAutoSave()
            }
            .onAppear {
                viewModel.onSubmitTapped = handleDone
            }
            .onDisappear {
                if !didComplete { onComplete() }
            }
    }

    private func runAutoSave() async {
        while !Task.isCancelled {
            await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                withObservationTracking {
                    _ = viewModel.model.title
                    _ = viewModel.model.description
                    _ = viewModel.model.ingredients
                    _ = viewModel.model.cookingTimeMins
                    _ = viewModel.model.complexity
                    _ = viewModel.model.imageSource
                    _ = viewModel.model.topTextBlock
                    _ = viewModel.model.steps
                    _ = viewModel.model.bottomTextBlock
                } onChange: {
                    continuation.resume()
                }
            }
            try? await Task.sleep(for: .seconds(1.5))
            guard !Task.isCancelled, !viewModel.isSaving else { continue }
            if viewModel.model.title.trimmingCharacters(in: .whitespaces).isEmpty {
                viewModel.model.title = RecipeDraftModel.defaultTitle()
            }
            try? await saver.save(viewModel.model.toRecipe(isDraft: true))
        }
    }

    private func handleDone() {
        guard !viewModel.isSaving else { return }
        viewModel.fieldErrors.removeAll()
        viewModel.saveError = nil
        savingTask?.cancel()

        let scenario = FormSubmitScenario<RecipeDraftModel, Recipe>(
            getModel: { [weak viewModel] in viewModel?.model },
            validate: { draftModel in
                let recipe = await draftModel.toRecipe()
                let errors = RecipeFormValidator.validate(recipe)
                return errors.isEmpty ?
                    .success(recipe) :
                    .failure(FormValidationError(form: nil, field: errors))
            },
            save: { [saver] in try await saver.save($0) }
        )

        savingTask = Task { [weak viewModel] in
            for await state in scenario.start() {
                RecipeEditScreenAssembly.updateModel(viewModel, with: state, onSuccess: { [self] in
                    didComplete = true
                    dismiss()
                    onComplete()
                })
            }
        }
    }

    private func handleDelete() {
        Task {
            try? await deleter.delete(id: viewModel.model.id)
            didComplete = true
            dismiss()
            onComplete()
        }
    }
}
