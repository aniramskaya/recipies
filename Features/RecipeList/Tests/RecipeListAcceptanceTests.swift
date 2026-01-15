//
//  RecipeListAcceptanceTests.swift
//  RecipieListTests
//
//  Created by Марина Чемезова on 05.01.2026.
//

import Testing
import SwiftUI
import UIKit
import TestHelpers
import ViewInspector

@testable import RecipieList

/*
 Что тестируем
 Базовый сценарий: загрузка -> ошибка -> нажатие кнопки "повторить" -> загрузка -> успех
 Дополнительный (чтобы ничего не пропустить): загрузка -> успех -> юзер использует PTR -> загружаются новые данные
 
 */

struct RecipeListAcceptanceTests {
    let leakChecker = LeakChecker()
    
    @MainActor
    @Test func basicScenario() async throws {
        let (feature, server, user) = makeFeature()
        
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
    func makeFeature() -> (feature: RecipeListFeature, server: Server, user: RecipeListUser) {
        let server = Server()
        let expiration = TimestampExpirationPolicyStub()
        let (screen, leakable) = RecipeListAssembly.composeInternal(dtoLoader: server, cacheExpirationPolicy: expiration)
        let feature = RecipeListFeature(view: screen)
        leakChecker.track([server, expiration])
        leakChecker.track(leakable)
        leakChecker.track(feature)
        return (feature, server, feature)
    }
}

@MainActor
protocol RecipeListUser {
    func tapReloadButton() throws
}

@MainActor 
class RecipeListFeature: RecipeListUser {
    let view: RecipeListScreen
    var host: (UIWindow, UIViewController)?
    
    init(view: RecipeListScreen) {
        self.view = view
    }
    
    func start() {
        host = hostInWindow(view)
    }
    
    @MainActor
    func ensureIsDisplayingLoadingState(sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let inspectable = try self.view.inspect()
            let _ = try inspectable.find(viewWithAccessibilityIdentifier: LoadingViewA11y.component)
            return true
        }
    }

    @MainActor
    func ensureIsDisplayingError(text: String, sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let inspectable = try self.view.inspect()
            let errorView = try inspectable.find(viewWithAccessibilityIdentifier: ErrorViewA11y.errorText)
            let errorText = try errorView.text().string()
            return errorText == text
        }
    }
    
    @MainActor
    func ensureIsDisplayingData(model: [(name: String, rating: String, cookingTime: String)], sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return false }
            let inspectable = try view.inspect()
            let cells = inspectable.findAll(RecipeListRow.self)
            guard cells.count == model.count else {
                throw TestError(reason: "Expected \(model.count) recipe rows, found \(cells.count) instead")
            }
            for (index, cell) in cells.enumerated() {
                let item = model[index]
                try cell.assertIsDisplaying(
                    name: item.name,
                    rating: item.rating,
                    cookingTime: item.cookingTime
                )
            }
            return true
        }
    }
    
    // MARK: RecipeListUser
    
    @MainActor
    func tapReloadButton() throws {
        let inspectable = try view.inspect()
        let reloadButton = try inspectable.find(viewWithAccessibilityIdentifier: ErrorViewA11y.retryButton).button()
        try reloadButton.tap()
    }
}


class Server: RecipeListDTOLoader {
    var completions: [(Result<RecipeListDTO, Error>) -> Void] = []
    private var onLoad: (() -> Void)?
    
    func load(completion: @escaping (Result<RecipeListDTO, Error>) -> Void) {
        completions.append(completion)
        if let onLoad {
            onLoad()
            self.onLoad = nil
        }
    }
    
    func waitForRequest(index: Int) async {
        await withCheckedContinuation { continuation in
            onLoad = {
                continuation.resume()
            }
            if completions.count > index {
                onLoad = nil
                continuation.resume()
                return
            }
        }
    }
    
    func respond(with result: Result<RecipeListDTO, Error>, at index: Int? = nil) async throws {
        await waitForRequest(index: index ?? 0)
        completions[index ?? completions.endIndex - 1](result)
    }
}

private func testModels() -> [(name: String, rating: String, cookingTime: String)] {
    [
        (
            name: "Котлеты по-киевски",
            rating: "3.5",
            cookingTime: "75 min",
        ),
        (
            name: "Лапша Удон с курицей",
            rating: "4.8",
            cookingTime: "35 min",
        )
    ]
}


