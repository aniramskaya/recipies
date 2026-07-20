//
//  RecipeDetailView.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 20.07.2026.
//

import SwiftUI
import RecipeUIKit

struct RecipeDetailViewModel {
    let imageSource: RecipeImageSource
    let cookingTimeMins: Int
    let complexity: Int
    let title: String
    let description: String?
    let ingredients: IngredientListModel
    let topText: TextBlockViewModel?
    let steps: [RecipeStepViewModel]
    let bottomText: TextBlockViewModel?

    let onShare: () -> Void
}

struct RecipeDetailView: View {
    let model: RecipeDetailViewModel
    
    var body: some View {
        ScrollView([.vertical]) {
            VStack(alignment: .leading, spacing: 0) {
                RecipeHeaderView(
                    imageSource: model.imageSource,
                    cookingTimeMins: model.cookingTimeMins,
                    complexity: model.complexity
                )
                
                Separator()
                
                RecipeTitleView(title: model.title)
                
                if let description = model.description {
                    Separator()
                    RecipeDescriptionView(description: description)
                }
                
                Separator()
                IngredientsBlock(model: model.ingredients, onShare: model.onShare)
                
                if let topText = model.topText {
                    Separator()
                    TextBlockView(model: topText)
                }
                
                Separator()
                RecipeCookingBlock(steps: model.steps)
                
                if let bottomText = model.bottomText {
                    Separator()
                    TextBlockView(model: bottomText)
                }
            }
        }
    }
}

#Preview {
    let model = RecipeDetailViewModel(
        imageSource: .uiImage(RecipeUIKitAssets.image(named: "kiev")!),
        cookingTimeMins: 45,
        complexity: 4,
        title: "Tikka Masala",
        description: "Нежные кусочки маринованной курицы, обжаренные на сильном огне, томятся в насыщенном соусе из спелых томатов, сливок и ароматных специй — гарам масала, имбиря, кориандра. Одно из самых знаменитых блюд индийской кухни, покорившее весь мир своим глубоким, бархатным вкусом.",
        ingredients: .init(items:[
            .init(isOn: false, name: "700 г куриных бёдер без кожи"),
            .init(isOn: false, name: "120 г натурального йогурта"),
            .init(isOn: false, name: "2 зубчика чеснока"),
            .init(isOn: false, name: "1 ч.л. тёртого имбиря"),
        ]),
        topText: .init(
            id: .init(),
            text: "Маринуйте курицу не менее часа, лучше — ночь в холодильнике. Обжаривайте небольшими порциями, чтобы кусочки подрумянились. Соус можно приготовить заранее — настоявшись, он становится ещё ароматнее.",
            title: "Советы"
        ),
        steps: [
            .init(
                step: 1,
                title: "Маринование",
                imageSource: .uiImage(RecipeUIKitAssets.image(named: "kiev")!),
                text: "Нарежьте куриные бёдра на кусочки 4–5 см. Смешайте с йогуртом, чесноком, имбирём и специями маринада. Накройте и оставьте в холодильнике минимум на 1 час."
            ),
            .init(step: 2, title: "Обжарка", imageSource: nil, text: "Разогрейте сковороду-гриль на сильном огне. Обжаривайте курицу порциями по 3–4 мин с каждой стороны до золотистых подпалин. Отложите в сторону.")
        ],
        bottomText: .init(id: .init(), text: "Подавайте горячим с рисом басмати или свежими лепёшками наан. Блюдо хранится в холодильнике до 3 дней и прекрасно разогревается.", title: nil),
        onShare: {}
    )
    RecipeDetailView(model: model)
}
