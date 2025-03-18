//
//  LogManager.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-03-18.
//

import SwiftUI

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
