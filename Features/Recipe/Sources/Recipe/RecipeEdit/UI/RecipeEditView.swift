//
//  RecipeEditView.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.05.2026.
//
import SwiftUI



struct RecipeEditView: View {
    @Bindable var dataModel: RecipeDraftModel

    var body: some View {
        // let _ = Self._printChanges()
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HeaderEditView(value: $dataModel.title)
                Divider()
                DescriptionEditView(text: $dataModel.description)
                Divider()
                IngredientsEditBlock(items: $dataModel.ingredients)
            }
        }
    }
}

#Preview("Заполненная форма") {
    let dataModel = RecipeDraftModel()
    dataModel.title = "Котлета по-киевски"
    dataModel.description = "Котлеты по-киевски – любимое многими блюдо, которое не все берутся приготовить. Не стоит опасаться, что что-то не выйдет. Вооружившись этим рецептом, у вас непременно получатся аккуратные, а главное – вкусные котлеты из нежнейшего куриного мяса с восхитительным ароматом сливочного масла и зелени."
    dataModel.ingredients = [
        .init(id: UUID(), name: "850 г куриного филе"),
        .init(id: UUID(), name: "180 г сливочного масла (размягчённое)"),
        .init(id: UUID(), name: "100 г муки"),
        .init(id: UUID(), name: "200 г панировочных сухарей")
    ]

    return RecipeEditViewPreviewWrapper(
        dataModel: dataModel
    )
}

private struct RecipeEditViewPreviewWrapper: View {
    @State var dataModel: RecipeDraftModel
    
    var body: some View {
        RecipeEditView(dataModel: dataModel)
    }
}
