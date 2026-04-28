//
//  RecipeListAsyncAcceptanceTests.swift
//  recipies
//
//  Created by Марина Чемезова on 08.04.2026.
//


import Testing
import SwiftUI
import UIKit
import TestHelpers
import ViewInspector

@testable import RecipeList

/*
 Что тестируем
 Базовый сценарий: загрузка -> ошибка -> нажатие кнопки "повторить" -> загрузка -> успех
 Дополнительный (чтобы ничего не пропустить): загрузка -> успех -> юзер использует PTR -> загружаются новые данные
 
 */

struct RecipeListAsyncAcceptanceTests {
    let leakChecker = LeakChecker()
    
    @MainActor
    @Test func loadErrorReloadResultScenario() async throws {
        let (feature, server, user, _) = makeFeature()
        
        feature.start()
        
        try await feature.ensureIsDisplayingLoadingState()

        try await server.respond(with: .failure(NSError.any()), at: 0)
        
        try await feature.ensureIsDisplayingError(text: "Не удалось загрузить список рецептов")

        try user.tapReloadButton()
        
        try await feature.ensureIsDisplayingLoadingState()
        
        try await server.respond(with: .success(RecipeListDTO.test()), at: 1)

        try await feature.ensureIsDisplayingData(model: testModels())
    }
    
    @MainActor
    @Test func loadResultReloadSecondResultScenario() async throws {
        let (feature, server, user, expiration) = makeFeature()
        
        feature.start()
                
        try await feature.ensureIsDisplayingLoadingState()
        
        try await server.respond(with: .success(RecipeListDTO.test()), at: 0)

        try await feature.ensureIsDisplayingData(model: testModels())


        expiration.validationResult = true
        try user.pullToRefresh()

        try await server.respond(with: .success(RecipeListDTO.test2()), at: 1)

        print("Waiting for second request")
        

        try await feature.ensureIsDisplayingData(model: testModels2())
    }
    
    @MainActor
    @Test func tapOnListItemCallsOnSelectItem() async throws {
        var selectItemCalls: [UUID] = []
        
        let (feature, server, user, _) = makeFeature() { selectItemCalls.append($0) }
        
        feature.start()
        
        try await server.respond(with: .success(RecipeListDTO.test()), at: 0)

        try await feature.ensureIsDisplayingData(model: testModels())
        
        try user.tapListItem(at: 0)
        
        #expect(selectItemCalls == [UUID(uuidString: "c1fb3a12-62fc-401e-861f-11594fe87c32")!])
    }
    
    @MainActor
    func makeFeature(onSelectItem: (@MainActor (_: UUID) -> Void)? = nil) -> (
        feature: RecipeListFeature,
        server: AsyncServer,
        user: RecipeListUser, expiration: TimestampExpirationPolicyStub
    ) {
        let server = AsyncServer()
        let expiration = TimestampExpirationPolicyStub()
        let (screen, leakable) = RecipeListAssembly.composeInternalWithAsyncServices(
            dtoLoader: server,
            cacheExpirationPolicy: expiration,
            onSelectItem: onSelectItem ?? { _ in }
        )
        let feature = RecipeListFeature(view: screen)
        leakChecker.track([server, expiration])
        leakChecker.track(leakable)
        leakChecker.track(feature)
        return (feature, server, feature, expiration)
    }
}


final class AsyncServer: AsyncRecipeListDTOLoader, @unchecked Sendable {
    var continuations: [CheckedContinuation<RecipeListDTO, Error>] = []
    private var onLoad: (() -> Void)?
    
    func load() async throws -> RecipeListDTO {
        return try await withCheckedThrowingContinuation { continuation in
            continuations.append(continuation)
            if let onLoad {
                onLoad()
                self.onLoad = nil
            }
        }
    }
    
    func waitForRequest(index: Int) async {
        await withCheckedContinuation { [weak self] continuation in
            self?.onLoad = {
                continuation.resume()
            }
            if self?.continuations.count ?? -1 > index {
                self?.onLoad = nil
                continuation.resume()
                return
            }
        }
    }
    
    func respond(with result: Result<RecipeListDTO, Error>, at index: Int? = nil) async throws {
        await waitForRequest(index: index ?? 0)
        continuations[index ?? 0].resume(with: result)
    }
}

private func testModels() -> [(name: String, complexity: Int, cookingTime: String)] {
    [
        (
            name: "Котлеты по-киевски",
            complexity: 3,
            cookingTime: "75 min",
        ),
        (
            name: "Лапша Удон с курицей",
            complexity: 2,
            cookingTime: "35 min",
        )
    ]
}

private func testModels2() -> [(name: String, complexity: Int, cookingTime: String)] {
    [
        (
            name: "Солянка сборная мясная",
            complexity: 4,
            cookingTime: "75 min",
        ),
        (
            name: "Лагман домашний",
            complexity: 3,
            cookingTime: "135 min",
        )
    ]
}
