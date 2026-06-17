//
//  SingleValueCacheStub.swift
//  Scenarios
//
//  Created by Марина Чемезова on 17.06.2026.
//

import Scenarios

actor SingleValueCacheStub<Data: Sendable>: SingleValueCache {
    typealias Data = Data
    
    var isValid = true
    var value: Data?

    func get() async -> Scenarios.CacheEntry<Data> {
        guard let value else { return .empty }
        return isValid ? .fresh(value) : .stale(value)
    }
    
    func set(data: Data) async {
        value = data
    }
    
    func clear() async {
        value = nil
    }
    
    func setIsValid(_ valid: Bool) {
        isValid = valid
    }
}
