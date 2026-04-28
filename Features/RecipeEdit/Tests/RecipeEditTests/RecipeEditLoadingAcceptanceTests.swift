#if canImport(UIKit)
/*
 Что тестируем:
 1. Загрузка → ошибка → "Повторить" → загрузка → успех
 2. Загрузка → успех → форма отображает данные рецепта
 */

import Testing
import UIKit
@testable import RecipeEdit

struct RecipeEditLoadingAcceptanceTests {
    let leakChecker = LeakChecker()

    @MainActor
    @Test func loadFailureRetrySuccessScenario() async throws {
        let (feature, server, user) = makeFeature()

        feature.start()

        try await feature.ensureIsDisplayingLoadingState()

        try await server.respond(with: .failure(NSError.any()), at: 0)

        try await feature.ensureIsDisplayingError()

        try user.tapRetryButton()

        try await feature.ensureIsDisplayingLoadingState()

        try await server.respond(with: .success(testRecipeData()), at: 1)

        try await feature.ensureIsDisplayingForm(data: testRecipeData())
    }

    @MainActor
    @Test func loadSuccessScenario() async throws {
        let (feature, server, _) = makeFeature()

        feature.start()

        try await feature.ensureIsDisplayingLoadingState()

        try await server.respond(with: .success(testRecipeData()), at: 0)

        try await feature.ensureIsDisplayingForm(data: testRecipeData())
    }

    @MainActor
    private func makeFeature() -> (RecipeEditFeature, RecipeEditServer, RecipeEditUser) {
        let server = RecipeEditServer()
        let (screen, leakable) = RecipeEditAssembly.composeInternal(loader: server)
        let feature = RecipeEditFeature(view: screen)
        leakChecker.track(server)
        leakChecker.track(leakable)
        leakChecker.track(feature)
        return (feature, server, feature)
    }
}

private func testRecipeData() -> RecipeData {
    RecipeData(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, name: "Котлета по-киевски", cookingTime: 35, complexity: 3)
}
#endif
