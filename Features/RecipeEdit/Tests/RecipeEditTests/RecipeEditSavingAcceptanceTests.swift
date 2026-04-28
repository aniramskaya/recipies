#if canImport(UIKit)
/*
 Что тестируем:
 1. Успешное сохранение → оверлей успеха появляется, затем исчезает
 2. Ошибка сохранения → оверлей ошибки появляется → закрывается по кнопке
 3. Сохранение с невалидными полями → сервис не вызывается, видим ошибки валидации
 */

import Testing
import UIKit
@testable import RecipeEdit

struct RecipeEditSavingAcceptanceTests {
    let leakChecker = LeakChecker()

    @MainActor
    @Test func successfulSaveShowsAndDismissesSuccessOverlay() async throws {
        let (feature, loader, saver, user) = makeFeature()

        feature.start()

        try await loader.respond(with: .success(validRecipeData()), at: 0)
        try await feature.ensureIsDisplayingForm(data: validRecipeData())

        try user.tapSaveButton()
        try await saver.respond(with: .success(()), at: 0)

        try await feature.ensureIsDisplayingSuccessOverlay()
        try await feature.ensureIsDisplayingNoSavingOverlay()
    }

    @MainActor
    @Test func failedSaveShowsErrorOverlayAndDismissesOnClose() async throws {
        let (feature, loader, saver, user) = makeFeature()

        feature.start()

        try await loader.respond(with: .success(validRecipeData()), at: 0)
        try await feature.ensureIsDisplayingForm(data: validRecipeData())

        try user.tapSaveButton()
        try await saver.respond(with: .failure(NSError.any()), at: 0)

        try await feature.ensureIsDisplayingErrorOverlay()

        try user.tapCloseErrorOverlay()

        try await feature.ensureIsDisplayingNoSavingOverlay()
    }

    @MainActor
    @Test func invalidFieldsDoNotTriggerSave() async throws {
        let (feature, loader, _, user) = makeFeature()

        feature.start()

        try await loader.respond(with: .success(validRecipeData()), at: 0)
        try await feature.ensureIsDisplayingForm(data: validRecipeData())

        try user.fillNameField("")
        try user.tapSaveButton()

        try await feature.ensureIsDisplayingNameError("Поле обязательно")
        try await feature.ensureIsDisplayingNoSavingOverlay()
    }

    @MainActor
    private func makeFeature() -> (RecipeEditFeature, RecipeEditServer, RecipeSaverServer, RecipeEditUser) {
        let loader = RecipeEditServer()
        let saver = RecipeSaverServer()
        let (screen, leakable) = RecipeEditAssembly.composeInternal(loader: loader, saver: saver)
        let feature = RecipeEditFeature(view: screen)
        leakChecker.track(loader)
        leakChecker.track(saver)
        leakChecker.track(leakable)
        leakChecker.track(feature)
        return (feature, loader, saver, feature)
    }
}

private func validRecipeData() -> RecipeData {
    RecipeData(id: RecipeId(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!), name: "Котлета по-киевски", cookingTime: 35, complexity: 3)
}
#endif
