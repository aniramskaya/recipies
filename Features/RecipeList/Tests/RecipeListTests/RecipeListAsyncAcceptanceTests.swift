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

@MainActor
struct RecipeListAsyncAcceptanceTests {
    let leakChecker = LeakChecker()
    
    @Test func loadErrorReloadResultScenario() async throws {
        do {
            let (feature, server, user) = makeFeature()
            
            feature.start()
            
            try await feature.ensureIsDisplayingLoadingState()
            
            try await server.respond(with: .failure(NSError.any()), at: 0)

            try await feature.ensureIsDisplayingError(text: "Не удалось загрузить список рецептов")

            try user.tapReloadButton()

            try await feature.ensureIsDisplayingLoadingState()

            try await server.respond(with: .success(RecipeListItem.makeTestItems()), at: 1)
            
            try await feature.ensureIsDisplayingData(model: testModels())
        }
        await leakChecker.awaitAllReleased()
    }
    
    @Test func loadResultReloadSecondResultScenario() async throws {
        do {
            let (feature, server, user) = makeFeature()
            
            feature.start()
            
            try await feature.ensureIsDisplayingLoadingState()
            
            try await server.respond(with: .success(RecipeListItem.makeTestItems()), at: 0)

            try await feature.ensureIsDisplayingData(model: testModels())

            try user.pullToRefresh()

            try await server.respond(with: .success(RecipeListItem.makeTestItems2()), at: 1)
            
            try await feature.ensureIsDisplayingData(model: testModels2())
        }
        await leakChecker.awaitAllReleased()
    }
    
    @Test func tapOnListItemCallsOnSelectItem() async throws {
        do {
            var selectItemCalls: [UUID] = []
            
            let (feature, server, user) = makeFeature() { selectItemCalls.append($0) }
            
            feature.start()
            
            try await server.respond(with: .success(RecipeListItem.makeTestItems()), at: 0)

            try await feature.ensureIsDisplayingData(model: testModels())

            try user.tapListItem(at: 0)
            
            #expect(selectItemCalls == [UUID(uuidString: "c1fb3a12-62fc-401e-861f-11594fe87c32")!])
        }
        await leakChecker.awaitAllReleased()
    }
    
    func makeFeature(onSelectItem: (@MainActor (_: UUID) -> Void)? = nil) -> (
        feature: RecipeListFeature,
        server: AsyncServer,
        user: RecipeListUser
    ) {
        let server = AsyncServer()
        let (screen, leakable) = RecipeListAssembly.composeInternalWithAsyncServices(
            loader: server,
            onSelectItem: onSelectItem ?? { _ in },
            onAddItem: {}
        )
        let feature = RecipeListFeature(view: screen)
        leakChecker.track([server, feature])
        leakChecker.track(leakable)
        return (feature, server, feature)
    }
}


final class AsyncServer: RecipeListLoader, @unchecked Sendable {
    var continuations: [CheckedContinuation<[RecipeListItem], Error>] = []
    private var onLoad: (() -> Void)?

    func load() async throws -> [RecipeListItem] {
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

    func respond(with result: Result<[RecipeListItem], Error>, at index: Int? = nil) async throws {
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
