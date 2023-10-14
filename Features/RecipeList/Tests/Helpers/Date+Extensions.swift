//
//  Date+Extensions.swift
//  RecipieListTests
//
//  Created by Марина Чемезова on 14.10.2023.
//

import Foundation

extension Date {
    func addingMinutes(_ value: Int) -> Date? {
        Calendar.current.date(byAdding: .minute, value: value, to: self)
    }
    func addingSeconds(_ value: Int) -> Date? {
        Calendar.current.date(byAdding: .second, value: value, to: self)
    }
}
