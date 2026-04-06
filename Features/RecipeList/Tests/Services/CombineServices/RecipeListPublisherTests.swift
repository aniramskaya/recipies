//
//  RecipeListPublisher.swift
//  RecipeListTests
//
//  Created by Марина Чемезова on 19.01.2026.
//

import Combine
import Testing
import AsyncAlgorithms
@testable import RecipeList

struct RecipeListPublisherTests {
    @Test func recipeListLoadingFailsWhenDTOLoadingFailed() async throws {
        let expectedError = NSError.any()
        let module = makeSUT(stubResult: .failure(expectedError))

        do {
            _ = try await Array(module.sut.values)
            #expect(Bool(false), "Expected to throw error but got nothing instead")
        } catch {
            #expect((error as NSError).isEqual(expectedError), "Expected \(expectedError) received \(error) instead")
        }
    }
    
    @Test func recipeListLoadingReturnsItemsOnDTOLoadingSuccess() async throws {
        let expectedData = RecipeListItem.makeTestItems()
        let module = makeSUT(stubResult: .success(RecipeListDTO.test()))

        await #expect(throws: Never.self, "Expected to get data got failure instead", sourceLocation: #_sourceLocation) {
            let results = try await Array(module.sut.values)
            #expect(results.count == 1, "Expected exactly 1 recipeList result, got \(results.count)")
            #expect( results.first == expectedData, "Expected \(expectedData), got \(results.first) instead")
        }

        await #expect(throws: Never.self, "Expected to get data from cache got failure instead", sourceLocation: #_sourceLocation) {
            _ = try await Array(module.cache.get(key: RecipeListCacheKey).values)
        }
    }
    
    @Test func recipeListLoadsFromCacheWhenDTOLoadingFailed() async throws {
        let expectedData = RecipeListItem.makeTestItems()
        let stubError = NSError.any()
        let module = makeSUT(stubResult: .failure(stubError))
        module.cache.set(key: RecipeListCacheKey, data: RecipeListDTO.test())

        await #expect(throws: Never.self, "Expected to get data got failure instead", sourceLocation: #_sourceLocation) {
            let results = try await Array(module.sut.values)
            #expect(results.count == 1, "Expected exactly 1 recipeList result, got \(results.count)")
            #expect( results.first == expectedData, "Expected \(expectedData), got \(results.first) instead")
        }
    }
    
    @Test func recipeListFailsWhenRemoteLoadingFailsAndCacheIsExpired() async throws {
        let expectedError = NSError.any()
        let module = makeSUT(stubResult: .failure(expectedError))
        module.cache.set(key: RecipeListCacheKey, data: RecipeListDTO.test())
        module.expiration.validationResult = false

        do {
            _ = try await Array(module.sut.values)
            #expect(Bool(false), "Expected to throw error but got nothing instead")
        } catch {
            #expect((error as NSError).isEqual(expectedError), "Expected \(expectedError) received \(error) instead")
        }
    }

    // MARK: Private
    
    private struct SUTModule {
        let sut: AnyPublisher<[RecipeListItem], Error>
        let cache: RecipeListDTOExpirableCache
        let expiration: TimestampExpirationPolicyStub
    }

    private func makeSUT(stubResult: Result<RecipeListDTO, Error>, file: StaticString = #filePath, line: UInt = #line) -> SUTModule {
        let publisherStub = RecipeListDTOPublisherStub(result: stubResult)
        let expiration = TimestampExpirationPolicyStub()
        expiration.validationResult = true
        let (sut, cache) = RecipeListLoaderPublisherAssembly.composeInternal(
            dtoLoader: publisherStub,
            cacheExpirationPolicy: expiration
        )

        return SUTModule(sut: sut, cache: cache, expiration: expiration)
    }
}
