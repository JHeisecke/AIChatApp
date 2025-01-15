//
//  Date+Extensions.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-15.
//

import Foundation

extension Date {
    static func now(days: Int = 0, hours: Int = 0) -> Date {
        let secondsInADay = 86400
        let secondsInAnHour = 3600
        let totalSeconds = (days * secondsInADay) + (hours * secondsInAnHour)
        return Date(timeIntervalSinceNow: TimeInterval(totalSeconds))
    }
}
