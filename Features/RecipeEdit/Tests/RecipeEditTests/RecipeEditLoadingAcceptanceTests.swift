#if canImport(UIKit)
/*
 Что тестируем:
 1. Загрузка → ошибка → "Повторить" → загрузка → успех
 2. Загрузка → успех → форма отображает данные рецепта
 */

import Testing
import UIKit
import TestHelpers
@testable import RecipeEdit

@MainActor
struct RecipeEditLoadingAcceptanceTests {
    let leakChecker = LeakChecker()

    @Test func loadFailureRetrySuccessScenario() async throws {
        do {
            let (feature, server, user) = makeFeature()
            
            feature.start()
            
            try await feature.ensureIsDisplayingLoadingState()
            
            try await server.respond(with: .failure(NSError.any()), at: 0)
            
            try await feature.ensureIsDisplayingError()
            
            try user.tapRetryButton()
            
            try await feature.ensureIsDisplayingLoadingState()
            
            try await server.respond(with: .success(testRecipeData()), at: 1)
            
            try await feature.ensureIsDisplayingForm(data: testRecipeData())
            
            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func loadSuccessScenario() async throws {
        do {
            let (feature, server, _) = makeFeature()
            
            feature.start()
            
            try await feature.ensureIsDisplayingLoadingState()
            
            try await server.respond(with: .success(testRecipeData()), at: 0)
            
            try await feature.ensureIsDisplayingForm(data: testRecipeData())
            
            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }
    
    @Test func noMemoryLeaksInInterruptedScenario() async throws {
        do {
            let (feature, _, _) = makeFeature()
            
            feature.start()
            
            try await feature.ensureIsDisplayingLoadingState()

            feature.finish()
        }

        await leakChecker.awaitAllReleased(timeout: 3)
    }

    private func makeFeature() -> (RecipeEditFeature, RecipeEditServer, RecipeEditUser) {
        let server = RecipeEditServer()
        let (screen, leakable) = RecipeEditScreenAssembly.composeInternal(
            recipeId: testRecipeData().id,
            loader: server,
        )
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
