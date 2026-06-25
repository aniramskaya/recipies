//
//  RecipeListViewModel.swift
//  recipes
//
//  Created by Марина Чемезова on 14.01.2026.
//

import Foundation
import RecipeUIKit

@MainActor
final class RecipeListScreenViewModel: ObservableObject {
    @Published var state: ResourceLoadState<[RecipeListRowModel]> = .loading

    var onAppear: () -> Void = {}
    var onDisappear: () -> Void = {}
    var onRetry: () -> Void = {}
    var onReload: @MainActor () async -> Void = { }
    var onSelectItem: @MainActor (_: UUID) -> Void = { _ in }
}
