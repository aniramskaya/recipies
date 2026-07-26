#if canImport(UIKit)
/*
 Что тестируем:
 1. Загрузка → ошибка → "Повторить" → загрузка → успех
 2. Загрузка → успех → отображение рецепта
 3. Нет утечек памяти при прерванной загрузке
 */

import Testing
import UIKit
import TestHelpers
@testable import RecipeEdit

@MainActor
struct RecipeDetailLoadingAcceptanceTests {
    let leakChecker = LeakChecker()

    @Test func loadFailureRetrySuccessScenario() async throws {
        do {
            let (feature, server) = makeFeature()

            feature.start()

            try await feature.ensureIsDisplayingLoadingState()

            try await server.respond(with: .failure(NSError.any()), at: 0)

            try await feature.ensureIsDisplayingError()

            try feature.tapRetryButton()

            try await feature.ensureIsDisplayingLoadingState()

            try await server.respond(with: .success(testRecipe()), at: 1)

            try await feature.ensureIsDisplayingRecipe(testRecipe())

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func loadSuccessScenario() async throws {
        do {
            let (feature, server) = makeFeature()

            feature.start()

            try await feature.ensureIsDisplayingLoadingState()

            try await server.respond(with: .success(testRecipe()), at: 0)

            try await feature.ensureIsDisplayingRecipe(testRecipe())

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func noMemoryLeaksInInterruptedScenario() async throws {
        do {
            let (feature, _) = makeFeature()

            feature.start()

            try await feature.ensureIsDisplayingLoadingState()

            feature.finish()
        }
        await leakChecker.awaitAllReleased(timeout: 3)
    }

    private func makeFeature() -> (RecipeDetailFeature, RecipeDetailServer) {
        let server = RecipeDetailServer()
        let (screen, leakable) = RecipeDetailScreenAssembly.composeInternal(loader: server)
        let feature = RecipeDetailFeature(view: screen)
        leakChecker.track(server)
        leakChecker.track(leakable)
        leakChecker.track(feature)
        return (feature, server)
    }
}

private func testRecipe() -> Recipe {
    Recipe(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
        imageSource: URL(string: "https://example.com/image.jpg")!,
        cookingTimeMins: 50,
        complexity: 3,
        title: "Баттер Чикен",
        description: nil,
        ingredients: [Ingredient(name: "Куриное филе")],
        topText: nil,
        steps: [RecipeStep(id: UUID(), title: "Шаг", imageSource: nil, text: "Описание")],
        bottomText: nil
    )
}
#endif
