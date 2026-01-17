//
//  RecipeListLoaderAssembly.swift
//  recipes
//
//  Created by Марина Чемезова on 13.01.2026.
//

public enum RecipeListLoaderAssembly {
    /// Композер загрузчика рецептов
    ///
    /// - Parameters:
    ///   - dtoLoader: Загрузчик dto
    /// - Returns: Собранный сервис загрузки рецептов
    public static func compose(dtoLoader: RecipeListDTOLoader) -> RecipeListLoader {
        return composeInternal(
            dtoLoader: dtoLoader,
            cacheExpirationPolicy: RecipeListExpirationPolicy(timeout: 300)
        ).0
    }

    /// Композер загрузчика рецептов для внутреннего использования, в том числе в тестах
    ///
    /// - Parameters:
    ///   - dtoLoader: Загрузчик dto
    ///   - cacheExpirationPolicy: Политика протухания кэша
    /// - Returns: Кортеж из собранного загрузчика и массива его коллаборантов. Массив коллаборантов используется в тестах для контроля утечек памяти
    static func composeInternal(
        dtoLoader: RecipeListDTOLoader,
        cacheExpirationPolicy: TimestampExpirationPolicy
    ) -> (RecipeListFallbackLoader, [AnyObject]) {
        let storage = InMemoryStorage<RecipeListStored>()
        let cache = RecipeListCache(storage: storage, expirationPolicy: cacheExpirationPolicy)
        let cacheAsync = RecipeListCacheAsync(cache: cache)
        let remoteLoader = RecipeListRemoteLoader(dtoLoader: dtoLoader, cache: cache, storage: storage)
        return (
            RecipeListFallbackLoader(first: remoteLoader, second: cacheAsync),
            [storage, cache, cacheAsync, remoteLoader]
        )
    }
}
