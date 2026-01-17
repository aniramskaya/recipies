//
//  RecipeListLoaderAssembly.swift
//  recipies
//
//  Created by Марина Чемезова on 13.01.2026.
//

public enum RecipeListLoaderAssembly {
    /// Композер загрузчика рецептов
    ///
    /// - Parameters:
    ///   - dtoLoader: Загрузчик dto
    /// - Returns: Собранный сервис загрузки рецептов
    public static func compose(dtoLoader: RecipeListDTOLoader) -> RecipieListLoader {
        return composeInternal(
            dtoLoader: dtoLoader,
            cacheExpirationPolicy: RecipieListExpirationPolicy(timeout: 300)
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
    ) -> (RecipieListFallbackLoader, [AnyObject]) {
        let storage = InMemoryStorage<RecipeListStored>()
        let cache = RecipieListCache(storage: storage, expirationPolicy: cacheExpirationPolicy)
        let cacheAsync = RecipieListCacheAsync(cache: cache)
        let remoteLoader = RecipieListRemoteLoader(dtoLoader: dtoLoader, cache: cache, storage: storage)
        return (
            RecipieListFallbackLoader(first: remoteLoader, second: cacheAsync),
            [storage, cache, cacheAsync, remoteLoader]
        )
    }
}
