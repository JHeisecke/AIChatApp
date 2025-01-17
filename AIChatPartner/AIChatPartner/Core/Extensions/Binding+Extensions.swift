//
//  Binding+Extensions.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-17.
//

import SwiftUI
import Foundation

extension Binding where Value == Bool {

    init<T: Sendable>(ifNotNil value: Binding<T?>) {
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}
