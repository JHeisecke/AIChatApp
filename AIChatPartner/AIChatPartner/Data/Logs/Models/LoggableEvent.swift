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

struct AnyLogabbleEvent: LoggableEvent {
    let eventName: String
    let parameters: [String : Any]?
    let type: LogType

    init(
        eventName: String,
        parameters: [String : Any]? = nil,
        type: LogType = .analytics
    ) {
        self.eventName = eventName
        self.parameters = parameters
        self.type = type
    }
}
