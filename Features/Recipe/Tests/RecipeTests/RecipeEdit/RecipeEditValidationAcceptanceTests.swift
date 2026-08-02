#if canImport(UIKit)
/*
 Что тестируем:
 1. Пустое название → ошибка под полем названия
 2. Пустая длительность → ошибка под полем длительности
 3. Нечисловая длительность → ошибка под полем длительности
 */

import Testing
import UIKit
import TestHelpers
@testable import Recipe

@MainActor
struct RecipeEditValidationAcceptanceTests {
    let leakChecker = LeakChecker()

    @Test func emptyNameShowsValidationError() async throws {
        do {
            let (feature, server, user) = makeFeature()
            
            feature.start()
            
            try await server.respond(with: .success(validRecipeData()), at: 0)
            try await feature.ensureIsDisplayingForm(data: validRecipeData())
            
            try user.fillNameField("")
            try user.tapSaveButton()
            
            try await feature.ensureIsDisplayingNameError("Поле обязательно")
            
            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func emptyCookingTimeShowsValidationError() async throws {
        do {
            let (feature, server, user) = makeFeature()
            
            feature.start()
            
            try await server.respond(with: .success(validRecipeData()), at: 0)
            try await feature.ensureIsDisplayingForm(data: validRecipeData())
            
            try user.fillCookingTimeField("")
            try user.tapSaveButton()
            
            try await feature.ensureIsDisplayingCookingTimeError("Поле обязательно")

            feature.finish()
        }
        
        await leakChecker.awaitAllReleased()
    }

    @Test func nonNumericCookingTimeShowsValidationError() async throws {
        do {
            let (feature, server, user) = makeFeature()
            
            feature.start()
            
            try await server.respond(with: .success(validRecipeData()), at: 0)
            try await feature.ensureIsDisplayingForm(data: validRecipeData())
            
            try user.fillCookingTimeField("abc")
            try user.tapSaveButton()
            
            try await feature.ensureIsDisplayingCookingTimeError("Введите корректное число")

            feature.finish()
        }
        
        await leakChecker.awaitAllReleased()
    }
    
    @Test func validationErrorsAreDismissedAfterCorrectInput() async throws {
        do {
            let (feature, server, user) = makeFeature()
            
            feature.start()
            
            try await server.respond(with: .success(validRecipeData()), at: 0)
            try await feature.ensureIsDisplayingForm(data: validRecipeData())
            
            try user.fillNameField("")
            try user.fillCookingTimeField("")
            try user.tapSaveButton()

            try await feature.ensureIsDisplayingNameError("Поле обязательно")
            try await feature.ensureIsDisplayingCookingTimeError("Поле обязательно")

            try user.fillNameField("name")
            try user.fillCookingTimeField("30")
            try user.tapSaveButton()
            
            try await feature.ensureIsDisplayingNoValidationErrors()

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    private func makeFeature() -> (RecipeEditFeature, RecipeEditServer, RecipeEditUser) {
        let server = RecipeEditServer()
        let (screen, leakable) = RecipeEditScreenAssembly.composeInternal(
            recipeId: validRecipeData().id,
            loader: server
        )
        let feature = RecipeEditFeature(view: screen)
        leakChecker.track(server)
        leakChecker.track(leakable)
        leakChecker.track(feature)
        return (feature, server, feature)
    }
}

private func validRecipeData() -> RecipeData {
    RecipeData(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, name: "Котлета по-киевски", cookingTime: 35, complexity: 3)
}
#endif
