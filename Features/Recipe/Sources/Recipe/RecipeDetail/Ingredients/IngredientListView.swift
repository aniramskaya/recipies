//
//  IngredientListView.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 04.07.2026.
//

import SwiftUI

@Observable
class IngredientListModel {
    var items: [IngredientModel]

    init(items: [IngredientModel]) {
        self.items = items
    }

    var uncheckedCount: Int {
        items.filter { !$0.isOn }.count
    }
}

struct IngredientListView: View {
    var model: IngredientListModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: RecipeStyles.Spacing.xSmall) {
            ForEach(model.items, id: \.name) { item in
                IngredientView(model: item)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    let model = IngredientListModel(items: [
        .init(isOn: false, name: "700 г куриных бёдер без кожи и без костей и тут длинный текст"),
        .init(isOn: false, name: "120 г натурального йогурта"),
        .init(isOn: false, name: "2 зубчика чеснока"),
        .init(isOn: false, name: "1 ч.л. тёртого имбиря"),
        .init(isOn: false, name: "1 ч.л. гарам масала"),
        .init(isOn: false, name: "1 ч.л. куркумы"),
        .init(isOn: false, name: "1 ч.л. паприки"),
    ])
    
    IngredientListView(model: model)
}
