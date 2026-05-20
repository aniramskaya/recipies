#if canImport(UIKit)
import Foundation
import Testing
import UIKit
import SwiftUI

// MARK: - NSError

extension NSError {
    static func any() -> NSError {
        NSError(domain: UUID().uuidString, code: 1)
    }
}

// MARK: - LeakChecker

private struct EntityLeakChecker: @unchecked Sendable {
    let sourceLocation: SourceLocation
    weak var weakObject: AnyObject?
}

@MainActor
final class LeakChecker {
    private var trackedEntities: [EntityLeakChecker] = []

    func track(_ object: AnyObject, sourceLocation: SourceLocation = #_sourceLocation) {
        trackedEntities.append(.init(sourceLocation: sourceLocation, weakObject: object))
    }

    func track(_ objects: [AnyObject], sourceLocation: SourceLocation = #_sourceLocation) {
        objects.forEach { track($0, sourceLocation: sourceLocation) }
    }
    
    func awaitAllReleased() async {
        // Sending value of non-Sendable type '() -> Bool' risks causing data races
        await waitFor {
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

enum TestError: LocalizedError {
    case memoryLeak(String)
    
    var errorDescription: String? {
        switch self {
        case .memoryLeak(let object):
            return "\(object) не освобождён. Возможна утечка памяти."
        }
    }
}

// MARK: - waitFor

@MainActor
func waitFor(
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

// MARK: - hostInWindow

@MainActor
func hostInWindow<V: View>(_ view: V, size: CGSize = .init(width: 375, height: 640)) -> (UIWindow, UIViewController) {
    let vc = UIHostingController(rootView: view)
    let window: UIWindow = {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return UIWindow(windowScene: scene)
        } else {
            return UIWindow(frame: CGRect(origin: .zero, size: size))
        }
    }()
    window.rootViewController = vc
    window.makeKeyAndVisible()
    vc.loadViewIfNeeded()
    vc.view.setNeedsLayout()
    vc.view.layoutIfNeeded()
    return (window, vc)
}
#endif
