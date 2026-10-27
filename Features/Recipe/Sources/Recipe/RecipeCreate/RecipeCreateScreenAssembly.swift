import SwiftUI
import Scenarios
import RecipeTypes

public enum RecipeCreateScreenAssembly {
    @MainActor
    public static func compose(
        loader: any RecipeDetailLoader,
        saver: any RecipeSaver,
        deleter: any RecipeDeleter,
    ) -> some View {
        
        let viewModel = RecipeCreateScreenViewModel(state: .loading)
        let loadingScenario = BasicLoadingScenario(loader: loader.load)

        var loadingTask: Task<Void, Never>? = nil
        let load = { [weak viewModel] in
            loadingTask?.cancel()
            loadingTask = Task { [weak viewModel] in
                let stream = loadingScenario.start()
                for await state in stream {
                    guard let viewModel else { return }
                    setLoadingState(state, viewModel: viewModel)
                }
            }
        }
        
        viewModel.onAppear = load
        viewModel.onRetry = load
        
        return RecipeCreateScreen(
            viewModel: viewModel,
            saver: saver,
            deleter: deleter
        )
        
        @MainActor
        func setLoadingState(
            _ state: BasicLoadingScenario<Recipe>.State,
            viewModel: RecipeCreateScreenViewModel
        ) {
            switch state {
            case .loading:
                viewModel.state = .loading
            case let .failure(error):
                viewModel.state = .failed(error)
            case let .loaded(recipe):
                viewModel.state = .loaded(recipe.asDraftModel())
            }
        }
    }
//    
//    @MainActor
//    private static func makeRecipeEditViewModel(
//        draft: RecipeDraftModel,
//        saver: any RecipeSaver,
//        deleter: any RecipeDeleter,
//    ) -> RecipeEditViewModel {
//        let result = RecipeEditViewModel(model: draft)
//        
//        result.onAppearTask = { [weak result] in
//            guard let result else { return }
//            await startAutoSave(viewModel: result, saver: saver)
//        }
//        result.onDeleteTapped = {
//            Task {
//                try? await deleter.delete(id: draft.id)
//  //            dismiss()
//            }
//        }
//        
//        var savingTask: Task<Void, Never>?
//        result.onSubmitTapped = { [weak result] in
//            guard let result, !result.isSaving else { return }
//            savingTask?.cancel()
//            savingTask = handleSubmit(viewModel: result, saver: saver)
//        }
//        
//        return result
//    }
//    
//    @MainActor
//    private static func startAutoSave(viewModel: RecipeEditViewModel, saver: any RecipeSaver) async {
//        while !Task.isCancelled {
//            await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
//                withObservationTracking {
//                    _ = viewModel.model.title
//                    _ = viewModel.model.description
//                    _ = viewModel.model.ingredients
//                    _ = viewModel.model.cookingTimeMins
//                    _ = viewModel.model.complexity
//                    _ = viewModel.model.imageSource
//                    _ = viewModel.model.topTextBlock
//                    _ = viewModel.model.steps
//                    _ = viewModel.model.bottomTextBlock
//                } onChange: {
//                    continuation.resume()
//                }
//            }
//            try? await Task.sleep(for: .seconds(1.5))
//            guard !Task.isCancelled, !viewModel.isSaving else { continue }
//            if viewModel.model.title.trimmingCharacters(in: .whitespaces).isEmpty {
//                viewModel.model.title = RecipeDraftModel.defaultTitle()
//            }
//            try? await saver.save(viewModel.model.toRecipe(isDraft: true))
//        }
//    }
//    
//    @MainActor
//    private static func handleSubmit(viewModel: RecipeEditViewModel, saver: any RecipeSaver) -> Task<Void, Never> {
//        viewModel.fieldErrors.removeAll()
//        viewModel.saveError = nil
//
//        let scenario = FormSubmitScenario<RecipeDraftModel, Recipe>(
//            getModel: { [weak viewModel] in viewModel?.model },
//            validate: { draftModel in
//                let recipe = await draftModel.toRecipe()
//                let errors = RecipeFormValidator.validate(recipe)
//                return errors.isEmpty ?
//                    .success(recipe) :
//                    .failure(FormValidationError(form: nil, field: errors))
//            },
//            save: { [saver] in try await saver.save($0) }
//        )
//
//        return Task { [weak viewModel] in
//            for await state in scenario.start() {
//                RecipeEditScreenAssembly.updateModel(viewModel, with: state, onSuccess: {
//                    //dismiss()
//                })
//            }
//        }
//    }
}
