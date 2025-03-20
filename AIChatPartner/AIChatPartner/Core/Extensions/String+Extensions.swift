//
//  String+Extensions.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-03-19.
//

import Foundation

extension String {
    static func toString(_ value: Any) -> String? {
        switch value {
        case let value as Date:
            value.formatted()
        case let array as [Any]:
            array.compactMap({ String.toString($0) }).sorted().joined(separator: ", ")
        case let value as CustomStringConvertible:
            String(describing: value)
        default:
            nil
        }
    }
}
