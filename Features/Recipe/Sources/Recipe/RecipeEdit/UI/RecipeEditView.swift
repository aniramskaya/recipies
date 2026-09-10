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
                Divider()
                TextBlockOptionalEditView(model: $dataModel.topTextBlock)
                Divider()
                RecipeCookingEditView(steps: $dataModel.steps)
                Divider()
                TextBlockOptionalEditView(model: $dataModel.bottomTextBlock)
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

#Preview("Заполненная форма") {
    @Previewable @State var dataModel = RecipeDraftModel(
        id: UUID(),
        title: "Котлета по-киевски",
        description: "Котлеты по-киевски – любимое многими блюдо, которое не все берутся приготовить. Не стоит опасаться, что что-то не выйдет. Вооружившись этим рецептом, у вас непременно получатся аккуратные, а главное – вкусные котлеты из нежнейшего куриного мяса с восхитительным ароматом сливочного масла и зелени.",
        ingredients: [
            IngredientDraftModel(id: UUID(), name: "850 г куриного филе"),
            IngredientDraftModel(id: UUID(), name: "180 г сливочного масла (размягчённое)"),
            IngredientDraftModel(id: UUID(), name: "100 г муки"),
            IngredientDraftModel(id: UUID(), name: "200 г панировочных сухарей")
        ],
        topTextBlock: TextBlockDraftModel(title: "Title", text: "Маринуйте курицу не менее часа, лучше — ночь в холодильнике. Обжаривайте небольшими порциями, чтобы кусочки подрумянились."),
        steps: [
            RecipeStepDraftModel(
                id: UUID(),
                title: "Приготовление",
                imageSource: nil,
                text: "Маринуйте курицу не менее часа, лучше — ночь в холодильнике. Обжаривайте небольшими порциями, чтобы кусочки подрумянились."),
        ],
        bottomTextBlock: nil
    )

    return RecipeEditView(dataModel: dataModel)
}
