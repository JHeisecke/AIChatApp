//
//  LogType.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-03-18.
//

import Foundation
import OSLog

enum LogType {
    /// Use 'info' for informative tasks. These are not considered analytics, issues or errors.
    case info
    /// Default type for analytics
    case analytics
    /// Issues or errors that should not occur, but will not negatively affect the user experience
    case warning
    /// Issues or errors that do negatively affect user experience.
    case severe

    var emoji: String {
        switch self {
        case .info:
            return "ℹ️"
        case .analytics:
            return "📈"
        case .warning:
            return "⚠️"
        case .severe:
            return "🚨"
        }
    }

    var OSLogType: OSLogType {
        switch self {
        case .info:
            return .info
        case .analytics:
            return .default
        case .warning:
            return .error
        case .severe:
            return .fault
        }
    }
}
