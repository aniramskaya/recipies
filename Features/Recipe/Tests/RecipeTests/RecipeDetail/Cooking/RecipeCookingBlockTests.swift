//
//  RecipeCookingBlockTests.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 17.07.2026.
//

import Testing
import ViewInspector
import RecipeUIKit
@testable import Recipe

struct RecipeCookingBlockTests {
    
    @MainActor
    @Test("Recipe cooking block displays steps")
    func recipeCookingBlockDisplaysSteps() throws {
        let sut = RecipeCookingBlock(steps: steps)
        let inspectable = try sut.inspect().find(RecipeCookingBlock.self)
        
        #expect(throws: Never.self) {
            try inspectable.assertIsDisplaying(steps: steps)
        }
    }
}

nonisolated(unsafe) private let steps: [RecipeStepViewModel] = [
    .init(
        id: .init(),
        title: "Маринование",
        imageSource: .uiImage(RecipeUIKitAssets.image(named: "kiev")!),
        text: "Нарежьте куриные бёдра на кусочки 4–5 см. Смешайте с йогуртом, чесноком, имбирём и специями маринада. Накройте и оставьте в холодильнике минимум на 1 час."
    ),
    .init(id: .init(), title: "Обжарка", imageSource: nil, text: "Разогрейте сковороду-гриль на сильном огне. Обжаривайте курицу порциями по 3–4 мин с каждой стороны до золотистых подпалин. Отложите в сторону.")
]
