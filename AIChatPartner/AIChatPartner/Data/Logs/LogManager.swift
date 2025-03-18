//
//  LogManager.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-03-18.
//

import SwiftUI

protocol LogService {
    func identifyUser(userId: String, email: String?)
    func addUserProperties(dict: [String: Any])
    func deleteUserProfile()

    func trackEvent(event: LoggableEvent)
    func trackScreenEvent(event: LoggableEvent)
}

protocol LoggableEvent {
    var eventName: String { get }
    var parameters: [String: Any]? { get }
}

struct ConsoleService: LogService {
    func identifyUser(userId: String, email: String?) {
        let string = """
Identify User
    userId: \(userId)
    email: \(email ?? "none")
"""
        print(string)
    }

    func addUserProperties(dict: [String: Any]) {
        var string = "Log User Properties"
        let sortedKeys = dict.keys.sorted()
        for key in sortedKeys {
            if let value = dict[key] {
                string += "\n   (key: \(key), value: \(value))"
            }
        }
        print(string)
    }

    func deleteUserProfile() {
        let string = """
Delete User Profile
"""
        print(string)
    }

    func trackEvent(event: any LoggableEvent) {
        var string = "\(event.eventName)"
        if let parameters = event.parameters, !parameters.isEmpty {
            let sortedKeys = parameters.keys.sorted()
            for key in sortedKeys {
                if let value = parameters[key] {
                    string += "\n   (key: \(key), value: \(value))"
                }
            }
        }
        print(string)
    }

    func trackScreenEvent(event: any LoggableEvent) {
        trackEvent(event: event)
    }
}

@MainActor
@Observable
class LogManager {
    private let services: [LogService]

    init(services: [LogService] = []) {
        self.services = services
    }

    func identifyUser(userId: String, email: String?) {
        for service in services {
            service.identifyUser(userId: userId, email: email)
        }
    }

    func addUserProperties(dict: [String: Any]) {
        for service in services {
            service.addUserProperties(dict: dict)
        }
    }

    func deleteUserProfile() {
        for service in services {
            service.deleteUserProfile()
        }
    }

    func trackEvent(event: LoggableEvent) {
        for service in services {
            service.trackEvent(event: event)
        }
    }

    func trackScreenEvent(event: LoggableEvent) {
        for service in services {
            service.trackScreenEvent(event: event)
        }
    }
}
