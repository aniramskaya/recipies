//
//  MemoryLeakChecker.swift
//  recipies
//
//  Created by Марина Чемезова on 14.01.2026.
//

import Testing

private struct EntityLeakChecker {
    let sourceLocation: SourceLocation
    weak var weakObject: AnyObject?
    
    init(weakObject: AnyObject? = nil, sourceLocation: SourceLocation) {
        self.weakObject = weakObject
        self.sourceLocation = sourceLocation
    }
}

class LeakChecker {
    private var trackedEntities: [EntityLeakChecker] = []
    
    func track(_ object: AnyObject, sourceLocation: SourceLocation = #_sourceLocation) {
        trackedEntities.append(.init(weakObject: object, sourceLocation: sourceLocation))
    }

    func track(_ objects: [AnyObject], sourceLocation: SourceLocation = #_sourceLocation) {
        for object in objects {
            track(object)
        }
    }

    deinit {
        for item in trackedEntities {
            guard let leaked = item.weakObject else {
                continue
            }
            #expect(Bool(false), "\(String(describing: type(of: leaked))) has not been deallocated. Potential memory leak", sourceLocation: item.sourceLocation)
        }
    }
}
