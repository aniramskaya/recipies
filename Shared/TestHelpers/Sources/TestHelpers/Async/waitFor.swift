//
//  waitFor.swift
//  TestHelpers
//
//  Created by Марина Чемезова on 25.05.2026.
//

import Foundation
import Testing

/// Polls `condition` at regular intervals until it returns `true` or the timeout expires.
///
/// Intended for acceptance tests that need to wait on asynchronous UI or state changes
/// without coupling to implementation details.
///
/// ```swift
/// await waitFor { try view.find(viewWithAccessibilityIdentifier: "saveButton") != nil }
/// ```
///
/// If `condition` throws, polling continues until the timeout;
/// the last thrown error is included in the failure message.
/// On timeout, the test fails via `#expect` at the caller's source location.
///
/// > Important: Tools like MallocStackLogger can slow execution enough to cause spurious
/// > timeouts. Disable them when running tests that rely on `waitFor`.
///
/// - Parameters:
///   - timeout: Maximum time to wait in seconds. Defaults to `1`.
///   - checkInterval: Delay between condition checks in seconds. Defaults to `0.05`.
///   - sourceLocation: Source location reported on failure. Defaults to the call site.
///   - condition: A throwing closure that returns `true` when the awaited state is reached.
@MainActor
public func waitFor(
    timeout: TimeInterval = 1,
    checkInterval: TimeInterval = 0.05,
    sourceLocation: SourceLocation = #_sourceLocation,
    _ condition: @escaping () throws -> Bool
) async {
    let deadline = Date().addingTimeInterval(timeout)
    var lastError: Error?

    while Date() < deadline {
        do {
            if try condition() { return }
            lastError = nil
        } catch {
            lastError = error
        }
        try? await Task.sleep(nanoseconds: UInt64(checkInterval * 1_000_000_000))
    }

    if let lastError {
        #expect(Bool(false), "waitFor timed out. Last error: \(lastError)", sourceLocation: sourceLocation)
    } else {
        #expect(Bool(false), "waitFor timed out.", sourceLocation: sourceLocation)
    }
}
