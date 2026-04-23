import Foundation

enum TestError: Error, Equatable {
    case stub
    case primary
    case secondary
}

actor Box<T> {
    var value: T
    init(_ value: T) { self.value = value }
    func set(_ newValue: T) { value = newValue }
}
