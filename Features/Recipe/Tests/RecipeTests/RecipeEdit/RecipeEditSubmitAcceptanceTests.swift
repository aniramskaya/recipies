#if canImport(UIKit)
/*
 Что тестируем:
 1. Успешное сохранение: форма блокируется, спиннер в toolbar, вызов сервера, колбэк onSave
 2. Ошибка валидации при пустом названии: показывается ошибка, сохранение не вызывается
 3. Ошибка валидации при пустом описании: показывается ошибка, сохранение не вызывается
 4. Текстовый блок с пустым текстом: показывается ошибка, сохранение не вызывается
 5. Шаг рецепта с пустым текстом: показывается ошибка, сохранение не вызывается
 */

import Testing
import UIKit
import TestHelpers
@testable import Recipe

@MainActor
struct RecipeEditSubmitAcceptanceTests {
    let leakChecker = LeakChecker()

    @Test func successfulSaveScenario() async throws {
        do {
            let (feature, saver) = makeFeature()
            feature.start()

            try feature.userTapsSave()

            try await feature.ensureIsSaving()
            try await feature.ensureFormIsDisabled()

            try await saver.respond(with: .success(()), at: 0)

            try await feature.ensureOnSaveWasCalled()

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func emptyTitleShowsValidationErrorAndBlocksSave() async throws {
        do {
            let (feature, saver) = makeFeature(title: "", description: "Описание")
            feature.start()

            try feature.userTapsSave()

            try await feature.ensureIsDisplayingTitleValidationError()
            try feature.ensureSaveWasNotAttempted(saver: saver)

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func emptyDescriptionShowsValidationErrorAndBlocksSave() async throws {
        do {
            let (feature, saver) = makeFeature(title: "Рецепт", description: "")
            feature.start()

            try feature.userTapsSave()

            try await feature.ensureIsDisplayingDescriptionValidationError()
            try feature.ensureSaveWasNotAttempted(saver: saver)

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func textBlockWithEmptyTextShowsValidationError() async throws {
        do {
            let topTextBlock = TextBlockDraftModel(title: "Введение", text: "")
            let (feature, saver) = makeFeature(topTextBlock: topTextBlock)
            feature.start()

            try feature.userTapsSave()

            try await feature.ensureIsDisplayingTextBlockValidationError()
            try feature.ensureSaveWasNotAttempted(saver: saver)

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    @Test func stepWithEmptyTextShowsValidationError() async throws {
        do {
            let step = RecipeStepDraftModel(id: UUID(), title: "Шаг 1", imageSource: nil, text: "")
            let (feature, saver) = makeFeature(steps: [step])
            feature.start()

            try feature.userTapsSave()

            try await feature.ensureIsDisplayingStepTextValidationError()
            try feature.ensureSaveWasNotAttempted(saver: saver)

            feature.finish()
        }
        await leakChecker.awaitAllReleased()
    }

    // MARK: - makeFeature

    private func makeFeature(
        title: String = "Рецепт",
        description: String = "Описание",
        topTextBlock: TextBlockDraftModel? = nil,
        steps: [RecipeStepDraftModel] = []
    ) -> (RecipeEditModalFeature, RecipeEditSaverStub) {
        let saver = RecipeEditSaverStub()
        let model = RecipeDraftModel(
            id: UUID(),
            title: title,
            description: description,
            ingredients: [],
            topTextBlock: topTextBlock,
            steps: steps,
            bottomTextBlock: nil
        )
        let (screen, leakable) = RecipeEditScreenAssembly.composeInternal(model: model, saver: saver)
        let feature = RecipeEditModalFeature(view: screen)
        leakChecker.track(saver)
        leakChecker.track(leakable)
        leakChecker.track(feature)
        return (feature, saver)
    }
}
#endif
