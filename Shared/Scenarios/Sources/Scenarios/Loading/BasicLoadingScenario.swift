//
//  BasicLoadingScenario.swift
//  Scenarios
//
//  Created by Марина Чемезова on 12.05.2026.
//

import Foundation

/// A one-shot loading scenario that wraps an async throwing closure and emits a stream of ``LoadingScenarioState`` values.
///
/// Create a scenario with a loader closure, then call ``start()`` each time you want to trigger a load.
/// Every call to `start()` produces an independent stream and runs the loader from scratch,
/// making it safe to retry after failure.
///
/// ```swift
/// let scenario = BasicLoadingScenario { try await api.fetchRecipe(id: id) }
///
/// for await state in scenario.start() {
///     switch state {
///     case .loading:  showSpinner()
///     case .loaded(let recipe): show(recipe)
///     case .failure(let error): showError(error)
///     }
/// }
/// ```
public final class BasicLoadingScenario<Data: Sendable>: Sendable {
    private let load: @Sendable () async throws -> Data

    /// Creates a scenario with the given async loader.
    ///
    /// - Parameter loader: An async throwing closure that fetches and returns the resource.
    public init(loader: @escaping @Sendable () async throws -> Data) {
        self.load = loader
    }

    // MARK: LoadingScenario

    /// Starts the loading process and returns an `AsyncStream` of state updates.
    ///
    /// The stream emits states in the following order:
    /// 1. `.loading` — emitted immediately before the fetch begins.
    /// 2. `.loaded(data)` — emitted on success, then the stream completes.
    /// 3. `.failure(error)` — emitted if the loader throws, then the stream completes.
    ///
    /// Cancellation is checked after the initial yield and after the fetch returns,
    /// so the stream may finish without emitting a result if cancelled mid-flight.
    /// Abandoning the returned stream cancels the underlying load task automatically.
    ///
    /// - Returns: An `AsyncStream` that emits at most two values and always completes.
    public func start() -> AsyncStream<LoadingScenarioState<Data>> {
        let (stream, continuation) = AsyncStream.makeStream(
            of: LoadingScenarioState<Data>.self,
            bufferingPolicy: .bufferingNewest(1)
        )
        let load = self.load
        let task = Task {
            continuation.yield(.loading)

            guard !Task.isCancelled else { continuation.finish(); return }

            do {
                let data = try await load()
                guard !Task.isCancelled else {
                    print("Loading cancelled")
                    continuation.finish();
                    return
                }
                continuation.yield(.loaded(data))
                continuation.finish()
            } catch {
                guard !Task.isCancelled else { continuation.finish(); return }
                continuation.yield(.failure(error))
                continuation.finish()
            }
        }
        continuation.onTermination = { _ in
            print("Cancelling AsyncStream")
            task.cancel()
        }
        return stream
    }
}
