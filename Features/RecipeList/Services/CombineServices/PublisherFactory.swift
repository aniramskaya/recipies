//
//  PublisherFactory.swift
//  recipies
//
//  Created by Марина Чемезова on 08.04.2026.
//

import Combine

struct PublisherFactory<Output, Failure: Error>: @unchecked Sendable {
    let make: () -> AnyPublisher<Output, Failure>
}
