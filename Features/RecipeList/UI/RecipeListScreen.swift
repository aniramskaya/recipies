//
//  RecipeListScreen.swift
//  RecipieList
//
//  Created by Марина Чемезова on 05.01.2026.
//

import SwiftUI

struct RecipeListAsyncLoader {
    let loader: RecipieListLoader
    init(loader: RecipieListLoader) {
        self.loader = loader
    }
    
    func load() async throws -> [RecipeListItem] {
        try await withCheckedThrowingContinuation { continuation in
            loader.load { result in
                continuation.resume(with: result)
            }
        }
    }
}

enum RecipeListScreenViewState {
    case loading
    case error(Error)
    case data([RecipeListRowModel])
}

@MainActor
final class RecipeListViewModel: ObservableObject {
    @Published private(set) var state: RecipeListScreenViewState = .loading
    private let loader: RecipeListAsyncLoader
    
    init(loader: RecipeListAsyncLoader) {
        self.loader = loader
    }
    
    func loadRecipes() async {
        state = .loading
        do {
            let data = try await loader.load()
            state = .data(data.map { item in
                item.asViewModel()
            })
        } catch {
            state = .error(error)
        }
    }
}

extension RecipeListItem {
    func asViewModel() -> RecipeListRowModel {
        .init(
            id: self.id,
            name: self.name,
            imageSource: .remote(self.imageUrl),
            cookingTimeMins: Int(floor(self.cookingTime / 60)),
            rating: self.rating ?? 0
        )
    }
}

struct RecipeListScreen: View {
    @ObservedObject var viewModel: RecipeListViewModel
    
    var body: some View {
        content
            .task {
                await viewModel.loadRecipes()
            }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case let .data(model):
            RecipeListView(model: model)
        case let .error(error):
            ErrorView(error: "Не удалось загрузить список рецептов") {
                Task { await viewModel.loadRecipes() }
            }
        default:
            LoadingView()
        }
    }
}
