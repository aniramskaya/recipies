#if canImport(UIKit)
/*
 Что тестируем:
 1. Пустое название → ошибка под полем названия
 2. Пустая длительность → ошибка под полем длительности
 3. Нечисловая длительность → ошибка под полем длительности
 */

import Testing
import UIKit
@testable import RecipeEdit

struct RecipeEditValidationAcceptanceTests {
    let leakChecker = LeakChecker()

    @MainActor
    @Test func emptyNameShowsValidationError() async throws {
        let (feature, server, user) = makeFeature()

        feature.start()

        try await server.respond(with: .success(validRecipeData()), at: 0)
        try await feature.ensureIsDisplayingForm(data: validRecipeData())

        try user.fillNameField("")
        try user.tapSaveButton()

        try await feature.ensureIsDisplayingNameError("Поле обязательно")
    }

    @MainActor
    @Test func emptyCookingTimeShowsValidationError() async throws {
        let (feature, server, user) = makeFeature()

        feature.start()

        try await server.respond(with: .success(validRecipeData()), at: 0)
        try await feature.ensureIsDisplayingForm(data: validRecipeData())

        try user.fillCookingTimeField("")
        try user.tapSaveButton()

        try await feature.ensureIsDisplayingCookingTimeError("Поле обязательно")
    }

    @MainActor
    @Test func nonNumericCookingTimeShowsValidationError() async throws {
        let (feature, server, user) = makeFeature()

        feature.start()

        try await server.respond(with: .success(validRecipeData()), at: 0)
        try await feature.ensureIsDisplayingForm(data: validRecipeData())

        try user.fillCookingTimeField("abc")
        try user.tapSaveButton()

        try await feature.ensureIsDisplayingCookingTimeError("Введите корректное число")
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

private func validRecipeData() -> RecipeData {
    RecipeData(id: RecipeId(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!), name: "Котлета по-киевски", cookingTime: 35, complexity: 3)
}
#endif
