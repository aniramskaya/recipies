//
//  RecipeDetailTests.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 17.07.2026.
//

import Testing
import ViewInspector
import RecipeUIKit
@testable import RecipeEdit

struct RecipeDetailTests {

    @MainActor
    @Test("RecipeDetail displays model with all fields")
    func recipeDetailDisplaysAllFields() throws {
        let model = RecipeDetailViewModel(
            imageSource: .uiImage(RecipeUIKitAssets.image(named: "kiev")!),
            cookingTimeMins: 45,
            complexity: 4,
            title: "Tikka Masala",
            description: "Нежные кусочки маринованной курицы",
            ingredients: IngredientListModel(items: [
                .init(isOn: false, name: "700 г куриных бёдер"),
                .init(isOn: false, name: "120 г натурального йогурта"),
            ]),
            topText: .init(id: .init(), text: "Маринуйте курицу не менее часа", title: "Советы"),
            steps: [
                .init(step: 1, title: "Маринование", imageSource: nil, text: "Нарежьте курицу на кусочки"),
                .init(step: 2, title: "Обжарка", imageSource: nil, text: "Обжаривайте до румяной корочки"),
            ],
            bottomText: .init(id: .init(), text: "Подавайте горячим с рисом", title: nil),
            onShare: {}
        )

        let inspectable = try RecipeDetailView(model: model).inspect().find(RecipeDetailView.self)
        try inspectable.assertIsDisplaying(model: model)
    }

    @MainActor
    @Test("RecipeDetail displays model with mandatory fields only")
    func recipeDetailDisplaysMandatoryFieldsOnly() throws {
        let model = RecipeDetailViewModel(
            imageSource: .system("photo"),
            cookingTimeMins: 30,
            complexity: 2,
            title: "Простой рецепт",
            description: nil,
            ingredients: IngredientListModel(items: [
                .init(isOn: false, name: "Основной ингредиент"),
            ]),
            topText: nil,
            steps: [
                .init(step: 1, title: "Шаг", imageSource: nil, text: "Описание шага"),
            ],
            bottomText: nil,
            onShare: {}
        )

        let inspectable = try RecipeDetailView(model: model).inspect().find(RecipeDetailView.self)
        try inspectable.assertIsDisplaying(model: model)
    }
}
