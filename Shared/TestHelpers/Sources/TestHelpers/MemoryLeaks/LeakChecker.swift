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

@MainActor
public final class LeakChecker {
    private var trackedEntities: [EntityLeakChecker] = []
    
    public init() {}

    public func track(_ object: AnyObject, sourceLocation: SourceLocation = #_sourceLocation) {
        trackedEntities.append(.init(sourceLocation: sourceLocation, weakObject: object))
    }

    public func track(_ objects: [AnyObject], sourceLocation: SourceLocation = #_sourceLocation) {
        objects.forEach { track($0, sourceLocation: sourceLocation) }
    }
    
    public func awaitAllReleased() async {
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
