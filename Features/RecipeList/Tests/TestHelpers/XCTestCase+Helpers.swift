//
//  XCTestCase+Helpers.swift
//  recipies
//
//  Created by Марина Чемезова on 24.11.2023.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeak(
        _ object: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, "sut has not been deallocated. Possible memory leak!", file: file, line: line)
        }
    }
}
