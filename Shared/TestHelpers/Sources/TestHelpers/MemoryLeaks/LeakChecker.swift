//
//  LeakChecker.swift
//  TestHelpers
//
//  Created by Марина Чемезова on 25.05.2026.
//

import Testing
import Foundation

private struct EntityLeakChecker: @unchecked Sendable {
    let sourceLocation: SourceLocation
    weak var weakObject: AnyObject?
}

/// Tracks objects for memory leaks in acceptance tests.
///
/// Register objects with ``track(_:sourceLocation:)`` immediately after creation.
/// On deinitialization, `LeakChecker` verifies that every tracked object has been deallocated;
/// any surviving object causes a test failure at its registration call site.
///
/// Because the Swift concurrency runtime may hold a cancelled or completed `Task` alive
/// until it receives a scheduler turn, call ``awaitAllReleased()`` after releasing all strong
/// references to give async teardown chains enough time to finish:
///
/// ```swift
/// struct MyFeatureTests {
///     let leakChecker = LeakChecker()
///
///     @MainActor
///     @Test func loadSuccessScenario() async throws {
///         do {
///             let (feature, server, _) = makeFeature()
///             leakChecker.track(server)
///             leakChecker.track(feature)
///             feature.start()
///             try await feature.ensureIsDisplayingLoadingState()
///             try await server.respond(with: .success(data), at: 0)
///             try await feature.ensureIsDisplayingForm(data: data)
///             feature.finish()
///         } // strong references released here
///
///         await leakChecker.awaitAllReleased()
///     }
/// }
/// ```
@MainActor
public final class LeakChecker {
    private var trackedEntities: [EntityLeakChecker] = []

    public init() {}

    /// Registers an object for leak tracking.
    ///
    /// The object is held weakly, so tracking does not prevent deallocation.
    /// If the object is still alive when `LeakChecker` deinitializes, the test fails
    /// at `sourceLocation`.
    ///
    /// - Parameters:
    ///   - object: The object to track.
    ///   - sourceLocation: Source location reported on failure. Defaults to the call site.
    public func track(_ object: AnyObject, sourceLocation: SourceLocation = #_sourceLocation) {
        trackedEntities.append(.init(sourceLocation: sourceLocation, weakObject: object))
    }

    /// Registers multiple objects for leak tracking.
    ///
    /// Convenience overload for tracking an array of leakable objects returned by an assembly.
    /// Each object is registered individually with the same `sourceLocation`.
    ///
    /// - Parameters:
    ///   - objects: The objects to track.
    ///   - sourceLocation: Source location reported on failure. Defaults to the call site.
    public func track(_ objects: [AnyObject], sourceLocation: SourceLocation = #_sourceLocation) {
        objects.forEach { track($0, sourceLocation: sourceLocation) }
    }

    /// Waits until all tracked objects have been deallocated.
    ///
    /// Call this after releasing all strong references to tracked objects, typically at the end
    /// of a `do` block. The method polls via ``waitFor(_:)`` and returns as soon as every
    /// tracked weak reference becomes `nil`.
    ///
    /// This is necessary because the Swift concurrency runtime holds a `Task` alive until it
    /// receives a scheduler turn, even after cancellation or normal completion. Without this
    /// call, `deinit` may fire before async teardown chains finish, causing false leak reports.
    public func awaitAllReleased(timeout: TimeInterval = 1, sourceLocation: SourceLocation = #_sourceLocation) async {
        await waitFor(timeout: timeout, sourceLocation: sourceLocation) {
            self.trackedEntities.allSatisfy { $0.weakObject == nil }
        }
    }

    deinit {
        for item in trackedEntities {
            guard let leaked = item.weakObject else { continue }
            #expect(
                Bool(false),
                "\(String(describing: type(of: leaked))) не освобождён. Возможна утечка памяти.",
                sourceLocation: item.sourceLocation
            )
        }
    }
}
