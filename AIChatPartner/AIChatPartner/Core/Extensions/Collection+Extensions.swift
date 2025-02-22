//
//  Collection+Extensions.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-22.
//

import Foundation

extension Collection {
    func first(upTo value: Int) -> [Element]? {
        guard !isEmpty else { return nil }
        let maxItems = Swift.min(count, value)
        return Array(prefix(maxItems))
    }

    func last(upTo value: Int) -> [Element]? {
        guard !isEmpty else { return nil }
        let maxItems = Swift.min(count, value)
        return Array(suffix(maxItems))
    }
}
