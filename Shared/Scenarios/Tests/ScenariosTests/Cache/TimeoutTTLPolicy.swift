//
//  TimeoutTTLCache.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//

import Foundation
import Testing
@testable import Scenarios

struct TimeoutTTLPolicyTests {
    @Test("Date is valid one second before expiration")
    func IsValidIfTimeoutNotReached() async throws {
        let sut = makeSUT()
        #expect(sut.isValid(savedAt: Date().addingTimeInterval(-4)))
    }
    
    @Test("Date is not valid when equals expiration")
    func IsNotValidIfTimeoutIsExact() async throws {
        let sut = makeSUT()
        #expect(sut.isValid(savedAt: Date().addingTimeInterval(-5)) == false)
    }
    
    @Test("Date is not valid one second after expiration")
    func IsNotValidIfTimeoutIsReached() async throws {
        let sut = makeSUT()
        #expect(sut.isValid(savedAt: Date().addingTimeInterval(-6)) == false)
    }
    
    private func makeSUT() -> TimeoutTTLPolicy {
        TimeoutTTLPolicy(timeout: 5)
    }
}
