//
//  LoggableEvent.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-03-18.
//

import Foundation

protocol LoggableEvent {
    var eventName: String { get }
    var parameters: [String: Any]? { get }
    var type: LogType { get }
}
