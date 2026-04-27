import Foundation
import SwiftUI

public enum RecipeEditAssembly {
    @MainActor
    static func composeInternal(
        loader: any RecipeLoader
    ) -> (RecipeEditScreen, [AnyObject]) {
        let viewModel = RecipeEditViewModel(loader: loader)
        let screen = RecipeEditScreen(viewModel: viewModel)
        return (screen, [viewModel])
    }
    
    @MainActor
    public static func compose(id: RecipeId) -> some View {
        let loader = RecipeLoaderStub()
        return composeInternal(loader: loader).0
    }
}
