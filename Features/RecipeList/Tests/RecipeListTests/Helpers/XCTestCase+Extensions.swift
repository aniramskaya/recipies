//
//  XCTestCase+Extensions.swift
//  RecipeListTests
//
//  Created by Марина Чемезова on 14.10.2023.
//

import XCTest

private final class WeakBox: @unchecked Sendable {
    weak var object: AnyObject?

    init(_ object: AnyObject) {
        self.object = object
    }
}

extension XCTestCase {
    func trackForMemoryLeak(_ object: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        
        let box = WeakBox(object)
        
        addTeardownBlock {
            XCTAssertNil(box.object, "sut has not been deallocated. Possible memory leak!", file: file, line: line)
        }
    }
}
