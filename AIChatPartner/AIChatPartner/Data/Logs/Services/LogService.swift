//
//  LogService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-03-18.
//

import Foundation

protocol LogService {
    func identifyUser(userId: String, email: String?)
    func addUserProperties(dict: [String: Any])
    func deleteUserProfile()

    func trackEvent(event: LoggableEvent)
    func trackScreenEvent(event: LoggableEvent)
}
