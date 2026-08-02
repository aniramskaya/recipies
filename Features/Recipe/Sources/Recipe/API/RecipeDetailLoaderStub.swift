//
//  RecipeDetailLoaderStub.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 21.07.2026.
//

import Foundation

final class RecipeDetailLoaderStub: RecipeDetailLoader {
    func load() async throws -> Recipe {
        try await Task.sleep(for: .seconds(1))
        return Recipe(
            id: UUID(uuidString: "a1b2c3d4-e5f6-7890-abcd-ef1234567890")!,
            imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Butter_Chicken_%26_Butter_Naan_-_Home_-_Chandigarh_-_India_-_0006.jpg/960px-Butter_Chicken_%26_Butter_Naan_-_Home_-_Chandigarh_-_India_-_0006.jpg")!,
            cookingTimeMins: 50,
            complexity: 3,
            title: "Баттер Чикен",
            description: "Сочная курица в нежном томатно-сливочном соусе с ароматными индийскими специями. Подаётся с наном или рисом.",
            ingredients: [
                Ingredient(name: "Куриное филе — 700 г"),
                Ingredient(name: "Йогурт — 150 мл"),
                Ingredient(name: "Лимонный сок — 2 ст. л."),
                Ingredient(name: "Гарам масала — 2 ч. л."),
                Ingredient(name: "Сливочное масло — 50 г"),
                Ingredient(name: "Помидоры — 400 г"),
                Ingredient(name: "Сливки 20% — 150 мл"),
            ],
            topText: nil,
            steps: [
                RecipeStep(
                    id: UUID(),
                    title: "Маринуем курицу",
                    imageSource: nil,
                    text: "Нарезаем курицу кубиками, смешиваем с йогуртом, лимонным соком и гарам масалой. Маринуем минимум 30 минут."
                ),
                RecipeStep(
                    id: UUID(),
                    title: "Обжариваем",
                    imageSource: nil,
                    text: "Обжариваем курицу на сковороде с маслом до появления подрумяненных краёв, 6–8 минут. Откладываем."
                ),
                RecipeStep(
                    id: UUID(),
                    title: "Варим соус",
                    imageSource: nil,
                    text: "Обжариваем лук и специи, добавляем помидоры, тушим 15 минут. Пюрируем блендером, вливаем сливки."
                ),
                RecipeStep(
                    id: UUID(),
                    title: "Соединяем",
                    imageSource: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Butter_Chicken_%26_Butter_Naan_-_Home_-_Chandigarh_-_India_-_0006.jpg/960px-Butter_Chicken_%26_Butter_Naan_-_Home_-_Chandigarh_-_India_-_0006.jpg")!,
                    text: "Возвращаем курицу в соус, томим 10 минут. Подаём с горячим наном или рисом."
                ),
            ],
            bottomText: nil
        )
    }
}
