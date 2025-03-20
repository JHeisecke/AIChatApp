//
//  ConsoleService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-03-18.
//

import Foundation
import OSLog

struct ConsoleService: LogService {

    let logger = LogSystem()
    private let printParameters: Bool

    init(printParameters: Bool = true) {
        self.printParameters = printParameters
    }

    func identifyUser(userId: String, email: String?) {
        let string = """
📈 Identify User
    userId: \(userId)
    email: \(email ?? "none")
"""
        logger.log(.info, message: string)
    }

    func addUserProperties(dict: [String: Any], isHighPriority: Bool) {
        var string = "📈 Log User Properties (isHighPriority: \(isHighPriority))"
        if printParameters {
            let sortedKeys = dict.keys.sorted()
            for key in sortedKeys {
                if let value = dict[key] {
                    string += "\n   (key: \(key), value: \(value))"
                }
            }
        }
        logger.log(.info, message: string)
    }

    func deleteUserProfile() {
        let string = """
📈 Delete User Profile
"""
        logger.log(.info, message: string)
    }

    func trackEvent(event: any LoggableEvent) {
        var string = "\(event.type.emoji) \(event.eventName)"
        if printParameters, let parameters = event.parameters, !parameters.isEmpty {
            let sortedKeys = parameters.keys.sorted()
            for key in sortedKeys {
                if let value = parameters[key] {
                    string += "\n   (key: \(key), value: \(value))"
                }
            }
        }
        logger.log(event.type, message: string)
    }

    func trackScreenEvent(event: any LoggableEvent) {
        trackEvent(event: event)
    }
}

// MARK: - LogSystem

actor LogSystem {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ConsoleLogger")

    func log(level: OSLogType, message: String) {
        logger.log(level: .debug, "\(message)")
    }

    nonisolated func log(_ logType: LogType, message: String) {
        Task {
            await log(level: logType.OSLogType, message: message)
        }
    }
}
