//
//  TTLPolicyStub.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//

import Foundation
@testable import Scenarios

final class TTLPolicyStub: TTLPolicy, @unchecked Sendable {
    var stubValid = true

    func isValid(savedAt: Date) -> Bool {
        stubValid
    }
}
