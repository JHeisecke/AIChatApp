//
//  Array+Extensions.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-26.
//

import Foundation

extension Array {
    func sortedByKeyPath<T: Comparable>(keyPath: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        self.sorted(by: { item1, item2 in
            let value1 = item1[keyPath: keyPath]
            let value2 = item2[keyPath: keyPath]
            return ascending ? (value1 < value2) : (value1 > value2)
        })
    }
}
