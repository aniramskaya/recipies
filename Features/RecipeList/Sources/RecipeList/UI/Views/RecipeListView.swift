//
//  RecipeListView.swift
//  RecipeList
//
//  Created by Марина Чемезова on 05.01.2026.
//

import SwiftUI
import RecipeUIKit

struct RecipeListView: View {
    let model: [RecipeListRowModel]
    let reload: @MainActor () async -> Void
    let onSelectItem: @MainActor (_: UUID) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(model, id: \.id) { item in
                    Button {
                        onSelectItem(item.id)
                    } label: {
                        RecipeListRow(model: item)
                            .listRowSeparator(.hidden)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier(RecipeListViewA11y.listItemButton)
                }
            }
        }
        .refreshable {
            await reload()
        }
    }
}

enum RecipeListViewA11y {
    static let listItemButton = "RecipeListItemButton"
}

#Preview {
    RecipeListView(
        model: [RecipeListRowModel(
            id: UUID(uuidString: "b0a1a334-09b3-4e61-87bf-0b05745388cf")!,
            name: "Котлета по-киевски",
            imageSource: .uiImage(RecipeUIKitAssets.image(named: "kiev")!),
            cookingTimeMins: 35,
            complexity: 3
        ), RecipeListRowModel(
            id: UUID(uuidString: "b0a1a334-09b3-4e61-87bf-0b05745388cd")!,
            name: "Котлета по-киевски",
            imageSource: .uiImage(RecipeUIKitAssets.image(named: "kiev")!),
            cookingTimeMins: 35,
            complexity: 3
        )],
        reload: {},
        onSelectItem: { _ in }
    )
}
