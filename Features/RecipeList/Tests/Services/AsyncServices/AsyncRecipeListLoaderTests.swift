//
//  AsyncRecipeListLoaderTests.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

import Testing
@testable import RecipeList

struct AsyncRecipeListLoaderTests {
    let leakChecker = LeakChecker()

    @Test func recipeListLoadingFailsWhenDTOLoadingFailed() async throws {
        let expectedError = NSError.any()
        let module = makeSUT(stubResults: [.failure(expectedError)])

        do {
            _ = try await module.sut.load()
            #expect(Bool(false), "Expected to throw error but got data instead")
        } catch {
            #expect((error as NSError).isEqual(expectedError), "Expected \(expectedError) received \(error) instead")
        }
        
        let numberOfLoads = await module.stub.resultIndex
        #expect(numberOfLoads == 1, "Expected to load data once, got called \(numberOfLoads) times instead")
    }
    
    @Test func recipeListLoadingReturnsItemsOnDTOLoadingSuccess() async throws {
        let expectedData = RecipeListItem.makeTestItems()
        let module = makeSUT(stubResults: [.success(RecipeListDTO.test())])

        await #expect(throws: Never.self, "Expected to get data got failure instead", sourceLocation: #_sourceLocation) {
            let results = try await module.sut.load()
            #expect( results == expectedData, "Expected \(expectedData), got \(results) instead")
        }
        let numberOfLoads = await module.stub.resultIndex
        #expect(numberOfLoads == 1, "Expected to load data once, got called \(numberOfLoads) times instead")
    }
    
    @Test func recipeListLoadsFromCacheWhenDTOLoadingFailed() async throws {
        let expectedData = RecipeListItem.makeTestItems()
        let stubError = NSError.any()
        let module = makeSUT(stubResults: [
            .success(RecipeListDTO.test()),
            .failure(stubError)
        ])

        await #expect(throws: Never.self, "Expected to get data got failure instead", sourceLocation: #_sourceLocation) {
            let results = try await module.sut.load()
            #expect( results == expectedData, "Expected \(expectedData), got \(results) instead")
        }
        await #expect(throws: Never.self, "Expected to get data got failure instead", sourceLocation: #_sourceLocation) {
            let results = try await module.sut.load()
            #expect( results == expectedData, "Expected \(expectedData), got \(results) instead")
        }
        let numberOfLoads = await module.stub.resultIndex
        #expect(numberOfLoads == 2, "Expected to load data twice, got called \(numberOfLoads) times instead")
    }
    
    @Test func recipeListFailsWhenRemoteLoadingFailsAndCacheIsExpired() async throws {
        let expectedData = RecipeListItem.makeTestItems()
        let stubError = NSError.any()
        let module = makeSUT(stubResults: [
            .success(RecipeListDTO.test()),
            .failure(stubError)
        ])
        
        await #expect(throws: Never.self, "Expected to get data got failure instead", sourceLocation: #_sourceLocation) {
            let results = try await module.sut.load()
            #expect( results == expectedData, "Expected \(expectedData), got \(results) instead")
        }
        module.expiration.validationResult = false
        do {
            _ = try await module.sut.load()
            #expect(Bool(false), "Expected to throw error but got data instead")
        } catch {
            #expect((error as NSError).isEqual(stubError), "Expected \(stubError) received \(error) instead")
        }

        let numberOfLoads = await module.stub.resultIndex
        #expect(numberOfLoads == 2, "Expected to load data twice, got called \(numberOfLoads) times instead")
    }

    // MARK: Private
    
    private struct SUTModule {
        let sut: RecipeListLoaderAsync
        let stub: AsyncRecipeListDTOLoaderStub
        let expiration: TimestampExpirationPolicyStub
    }

    private func makeSUT(stubResults: [Result<RecipeListDTO, Error>], file: StaticString = #filePath, line: UInt = #line) -> SUTModule {
        let publisherStub = AsyncRecipeListDTOLoaderStub(results: stubResults)
        let expiration = TimestampExpirationPolicyStub()
        expiration.validationResult = true
        let (sut, leakable) = AsyncRecipeListLoaderAssembly.composeInternal(
            dtoLoader: publisherStub,
            cacheExpirationPolicy: expiration
        )
        leakChecker.track(publisherStub)
        leakChecker.track(expiration)
        leakChecker.track(leakable)

        return SUTModule(sut: sut, stub: publisherStub, expiration: expiration)
    }}
