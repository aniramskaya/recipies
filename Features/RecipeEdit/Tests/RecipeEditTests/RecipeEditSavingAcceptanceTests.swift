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

@MainActor
struct RecipeEditSavingAcceptanceTests {
    let leakChecker = LeakChecker()

    @Test func successfulSaveShowsAndDismissesSuccessOverlay() async throws {
        do {
            let (feature, loader, saver, user) = makeFeature()
            
            feature.start()
            
            try await loader.respond(with: .success(validRecipeData()), at: 0)
            try await feature.ensureIsDisplayingForm(data: validRecipeData())
            
            try user.tapSaveButton()
            try await saver.respond(with: .success(()), at: 0)
            
            try await feature.ensureIsDisplayingSuccessOverlay()
            try await feature.ensureIsDisplayingNoSavingOverlay()
            
            feature.finish()
        }
        
        await leakChecker.awaitAllReleased()
    }

    @Test func failedSaveShowsErrorOverlayAndDismissesOnClose() async throws {
        do {
            let (feature, loader, saver, user) = makeFeature()
            
            feature.start()
            
            try await loader.respond(with: .success(validRecipeData()), at: 0)
            try await feature.ensureIsDisplayingForm(data: validRecipeData())
            
            try user.tapSaveButton()
            try await saver.respond(with: .failure(NSError.any()), at: 0)
            
            try await feature.ensureIsDisplayingErrorOverlay()
            
            try user.tapCloseErrorOverlay()
            
            try await feature.ensureIsDisplayingNoSavingOverlay()
            
            feature.finish()
        }
        
        await leakChecker.awaitAllReleased()
    }

    @Test func invalidFieldsDoNotTriggerSave() async throws {
        do {
            let (feature, loader, _, user) = makeFeature()
            
            feature.start()
            
            try await loader.respond(with: .success(validRecipeData()), at: 0)
            try await feature.ensureIsDisplayingForm(data: validRecipeData())
            
            try user.fillNameField("")
            try user.tapSaveButton()
            
            try await feature.ensureIsDisplayingNameError("Поле обязательно")
            try await feature.ensureIsDisplayingNoSavingOverlay()
            
            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    private func makeFeature() -> (RecipeEditFeature, RecipeEditServer, RecipeSaverServer, RecipeEditUser) {
        let loader = RecipeEditServer()
        let saver = RecipeSaverServer()
        let (screen, leakable) = RecipeEditScreenAssembly.composeInternal(
            recipeId: validRecipeData().id,
            loader: loader,
            saver: saver
        )
        let feature = RecipeEditFeature(view: screen)
        leakChecker.track(loader)
        leakChecker.track(saver)
        leakChecker.track(leakable)
        leakChecker.track(feature)
        return (feature, loader, saver, feature)
    }
}

private func validRecipeData() -> RecipeData {
    RecipeData(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, name: "Котлета по-киевски", cookingTime: 35, complexity: 3)
}
#endif
