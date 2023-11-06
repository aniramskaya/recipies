//
//  RecipieListExpirationPolicyTests.swift
//  RecipieListTests
//
//  Created by Марина Чемезова on 06.11.2023.
//

import Foundation
import XCTest
@testable import RecipieList

/*
 ✅ Если Data() - timestamp < expirationTimeout вернуть true
 ✅ Если Data() - timestamp == expirationTimeout вернуть false
 ✅ Если Data() - timestamp > expirationTimeout вернуть false
 */
/*
 If Data() - timestamp < expirationTimeout return true
 If Data() - timestamp == expirationTimeout return false
 If Data() - timestamp > expirationTimeout return false
 */

struct RecipieListExpirationPolicy: TimestampExpirationPolicy {
    let timeout: TimeInterval
    init(timeout: TimeInterval) {
        self.timeout = timeout
    }
    
    func isValid(_ timestamp: Date) -> Bool {
        Date().timeIntervalSince(timestamp) < timeout
    }
}

class RecipieListExpirationPolicyTests: XCTestCase {
    func test_isValid_returnsTrueIfTimestampIsLessThanExpirationTime() throws {
        let sut = RecipieListExpirationPolicy(timeout: 10)
        
        XCTAssertTrue(sut.isValid(Date() - 9))
    }
    
    func test_isValid_returnsFalseIfTimestampIsEqualToExpirationTime() throws {
        let sut = RecipieListExpirationPolicy(timeout: 10)
        
        XCTAssertFalse(sut.isValid(Date() - 10))
    }
    
    func test_isValid_returnsFalseIfTimestampIsGreaterThanExpirationTime() throws {
        let sut = RecipieListExpirationPolicy(timeout: 10)
        
        XCTAssertFalse(sut.isValid(Date() - 11))
    }
}
