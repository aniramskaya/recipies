import Foundation
import SwiftUI

public enum RecipeEditAssembly {
    @MainActor
    static func composeInternal(
        loader: any RecipeLoader,
        saver: any RecipeSaver = RecipeSaverStub()
    ) -> (RecipeEditScreen, [AnyObject]) {
        let formViewModel = RecipeFormViewModel(saver: saver)
        let loadingViewModel = RecipeLoadingViewModel(loader: loader, onLoaded: { [weak formViewModel] data in
            formViewModel?.populate(from: data)
        })
        let screen = RecipeEditScreen(loadingViewModel: loadingViewModel, formViewModel: formViewModel)
        return (screen, [loadingViewModel, formViewModel])
    }

    @MainActor
    public static func compose(id: RecipeId) -> some View {
        let loader = RecipeLoaderStub()
        return composeInternal(loader: loader).0
    }
}
