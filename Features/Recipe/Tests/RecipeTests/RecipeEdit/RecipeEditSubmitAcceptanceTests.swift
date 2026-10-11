#if canImport(UIKit)
/*
 Что тестируем:
 1. Успешное сохранение: форма блокируется, спиннер в toolbar, вызов сервера, колбэк onSave
 2. Ошибка валидации при пустом названии: показывается ошибка, сохранение не вызывается
 */

import Testing
import UIKit
import TestHelpers
@testable import Recipe

@MainActor
struct RecipeEditSubmitAcceptanceTests {
    let leakChecker = LeakChecker()
    
    @MainActor
    private class CallCountBox {
        var value = 0
    }
    
    private let onSaveCallCount = CallCountBox()

    @Test func successfulSaveScenario() async throws {
        do {
            let (feature, saver) = makeFeature()
            feature.start()

            try feature.userTapsSave()

            try await feature.ensureIsSaving()
            try await feature.ensureFormIsDisabled()

            try await saver.respond(with: .success(()), at: 0)

            await waitFor {
                onSaveCallCount.value == 1
            }

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func emptyTitleShowsValidationErrorAndBlocksSave() async throws {
        do {
            let (feature, saver) = makeFeature(title: "")
            feature.start()

            try feature.userTapsSave()

            try await feature.ensureIsDisplayingTitleValidationError(
                String(localized: .titleRequiredValidationError)
            )
            try feature.ensureSaveWasNotAttempted(saver: saver)

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    // MARK: - makeFeature

    private func makeFeature(
        title: String = "Рецепт",
        topTextBlock: TextBlockDraftModel? = nil,
        steps: [RecipeStepDraftModel] = []
    ) -> (RecipeEditModalFeature, RecipeEditSaverStub) {
        let saver = RecipeEditSaverStub()
        let model = RecipeDraftModel(
            id: UUID(),
            title: title,
            description: "",
            ingredients: [],
            topTextBlock: topTextBlock,
            steps: steps,
            bottomTextBlock: nil
        )
        let (screen, leakable) = RecipeEditScreenAssembly.composeInternal(
            model: model,
            saver: saver,
            onCancel: {},
            onSaveCompleted: {
                onSaveCallCount.value += 1
            }
        )
        let feature = RecipeEditModalFeature(view: screen)
        leakChecker.track(saver)
        leakChecker.track(leakable)
        leakChecker.track(feature)
        return (feature, saver)
    }
}
#endif
