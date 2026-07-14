//
//  IngredientListView.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 04.07.2026.
//

import SwiftUI

class IngredientListModel: ObservableObject {
    @Published var items: [IngredientModel]
    
    init(items: [IngredientModel]) {
        self.items = items
    }
}

struct IngredientListView: View {
    @ObservedObject var model: IngredientListModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(model.items, id: \.name) { item in
                IngredientView(model: item)
            }
        }
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
