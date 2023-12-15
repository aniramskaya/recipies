//
//  TimeoutPolicyTests.swift
//  RecipieList
//
//  Created by Марина Чемезова on 15.12.2023.
//

import Foundation
import XCTest
import RecipieList

/*
 ✅ Если от штампа времени прошло менее timeout секунд, возвращаем true
 ✅ Если от штампа времени прошло ровно timeout секунд, возвращаем false
 ✅ Если от штампа времени прошло более timeout секунд, возвращаем false
 */

class TimeoutPolicyTests: XCTestCase {
    func test_timeoutNotExpired_returnsTrue() throws {
        let sut = TimeoutPolicy(60)
        
        let isValid = sut.isValid(Date() - 59)
        
        XCTAssertTrue(isValid)
    }
    
    func test_timeoutIsExactlySame_returnsFalse() throws {
        let sut = TimeoutPolicy(60)
        
        let isValid = sut.isValid(Date() - 60)
        
        XCTAssertFalse(isValid)
    }
    
    func test_timeoutIsExpired_returnsFalse() throws {
        let sut = TimeoutPolicy(60)
        
        let isValid = sut.isValid(Date() - 61)
        
        XCTAssertFalse(isValid)
    }
}
