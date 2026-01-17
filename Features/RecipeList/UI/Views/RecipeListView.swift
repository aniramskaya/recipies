//
//  RecipeListView.swift
//  RecipieList
//
//  Created by Марина Чемезова on 05.01.2026.
//

import SwiftUI
import RecipeUIKit

struct RecipeListView: View {
    let model: [RecipeListRowModel]
    let reload: @MainActor () async -> Void
    
    var body: some View {
        List(model) { item in
            RecipeListRow(model: item)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .listRowSpacing(10)
        .scrollContentBackground(.hidden)
        .background(Color.white)
        .refreshable {
            print("AAAA Reloading started")
            await reload()
        }
    }
}

#Preview {
    RecipeListView(
        model: [RecipeListRowModel(
            id: UUID(uuidString: "b0a1a334-09b3-4e61-87bf-0b05745388cf")!,
            name: "Котлета по-киевски",
            imageSource: .uiImage(RecipeListUIAssets.image(named: "kiev")!),
            cookingTimeMins: 35,
            rating: 4.6
        ), RecipeListRowModel(
            id: UUID(uuidString: "b0a1a334-09b3-4e61-87bf-0b05745388cd")!,
            name: "Котлета по-киевски",
            imageSource: .uiImage(RecipeListUIAssets.image(named: "kiev")!),
            cookingTimeMins: 35,
            rating: 4.6
        )]) {
            
        }
}
