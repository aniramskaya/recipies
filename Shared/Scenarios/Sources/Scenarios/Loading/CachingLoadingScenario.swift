//
//  CachingLoadingScenario.swift
//  Scenarios
//
//  Created by Марина Чемезова on 17.06.2026.
//

/*
 
 load
 Кэша нет
    Ошибка загрузки возвращает ошибку
    Успешная загрузка возвращает данные
 Кэш есть и он свежий
    Возврат данных из кэша
 Кэш есть и он протух
    Возврат данных из кэша, затем загрузка
        Успех - возвращаются обновленные данные
        Ошибка - возвращаются старые данные
 
 reload
    Возврат данных из кэша (пустой, свежий или загрузка - неважно), затем загрузка
        Успех - возвращаются обновленные данные
        Ошибка - возвращаются старые данные

 */

public final class CachingLoadingScenario<Data: Sendable>: Sendable {
    /// The state of a loading operation managed by ``CachingLoadingScenario``.
    public struct State: Sendable {
        public let isLoading: Bool
        public let data: Data?
        public let error: Error?
    }
    
    private let cache: any SingleValueCache<Data>
    private let remoteLoader: @Sendable () async throws -> Data
    
    public init(cache: any SingleValueCache<Data>, loader: @escaping @Sendable () async throws -> Data) {
        self.cache = cache
        self.remoteLoader = loader
    }
    
    public func load() -> AsyncStream<State> {
        loadInternal(force: false)
    }

    public func reload() -> AsyncStream<State> {
        loadInternal(force: true)
    }

    private func loadInternal(force: Bool) -> AsyncStream<State> {
        let (stream, continuation) = AsyncStream.makeStream(
            of: State.self,
            bufferingPolicy: .bufferingNewest(1)
        )
        let task = Task {
            let data = await cache.get()
            guard !Task.isCancelled else { continuation.finish(); return }
            switch data {
            case .empty:
                continuation.yield(.init(isLoading: true, data: nil, error: nil))
                await loadFromRemote(cachedData: nil, continuation: continuation, onSuccess: cache.set)
            case let .fresh(value):
                if(force) {
                    continuation.yield(.init(isLoading: true, data: value, error: nil))
                    await loadFromRemote(cachedData: value, continuation: continuation, onSuccess: cache.set)
                } else {
                    continuation.yield(.init(isLoading: false, data: value, error: nil))
                    continuation.finish()
                }
            case let .stale(value):
                continuation.yield(.init(isLoading: true, data: value, error: nil))
                await loadFromRemote(cachedData: value, continuation: continuation, onSuccess: cache.set)
            }

        }
        continuation.onTermination = { _ in
            task.cancel()
        }
        return stream
    }
    
    private func loadFromRemote(
        cachedData: Data?,
        continuation:  AsyncStream<CachingLoadingScenario<Data>.State>.Continuation,
        onSuccess: (Data) async -> Void
    ) async {
        do {
            guard !Task.isCancelled else { continuation.finish(); return }
            let data = try await self.remoteLoader()
            await onSuccess(data)
            guard !Task.isCancelled else { continuation.finish(); return }
            continuation.yield(.init(isLoading: false, data: data, error: nil))
            continuation.finish()
        } catch {
            guard !Task.isCancelled else { continuation.finish(); return }
            continuation.yield(.init(isLoading: false, data: cachedData, error: error))
            continuation.finish()
        }
    }
}
