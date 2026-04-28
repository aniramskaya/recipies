import Foundation
import SwiftUI

public enum RecipeEditAssembly {
    @MainActor
    static func composeInternal(
        loader: any RecipeLoader
    ) -> (RecipeEditScreen, [AnyObject]) {
        let loadingViewModel = RecipeLoadingViewModel(loader: loader)
        let formViewModel = RecipeFormViewModel()
        loadingViewModel.onLoaded = { [weak formViewModel] data in
            formViewModel?.populate(from: data)
        }
        let screen = RecipeEditScreen(loadingViewModel: loadingViewModel, formViewModel: formViewModel)
        return (screen, [loadingViewModel, formViewModel])
    }

    @MainActor
    public static func compose(id: RecipeId) -> some View {
        let loader = RecipeLoaderStub()
        return composeInternal(loader: loader).0
    }
}
