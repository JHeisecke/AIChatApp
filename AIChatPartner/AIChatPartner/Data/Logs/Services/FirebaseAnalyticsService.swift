//
//  FirebaseAnalyticsService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-03-19.
//

import Foundation
import FirebaseAnalytics

struct FirebaseAnalyticsService: LogService {

    func identifyUser(userId: String, email: String?) {
        Analytics.setUserID(userId)
        if let email {
            Analytics.setUserProperty(email, forName: "user_email")
        }
    }
    
    func addUserProperties(dict: [String: Any], isHighPriority: Bool) {
        guard isHighPriority else { return }
        for (key, value) in dict {
            if let string = String.toString(value) {
                let cleanKey = key.clean(maxCharacters: 40)
                let cleanString = string.clean(maxCharacters: 100)
                Analytics.setUserProperty(cleanString, forName: cleanKey)
            }
        }
    }
    
    func deleteUserProfile() {

    }
    
    func trackEvent(event: LoggableEvent) {
        var parameters = event.parameters ?? [:]
        parameters.first(upTo: 25)
        for (key, value) in parameters {
            if key.count > 40 {
                parameters.removeValue(forKey: key)
                let newKey = key.clean(maxCharacters: 40)
                parameters[newKey] = updateKey(with: value)
                break
            }
            parameters[key] = updateKey(with: value)
        }
        let name = event.eventName.clean(maxCharacters: 40)
        Analytics.logEvent(name, parameters: parameters.isEmpty ? nil : parameters)
    }
    
    func trackScreenEvent(event: LoggableEvent) {
        let name = event.eventName.clean(maxCharacters: 40)
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: name
        ])
    }

    private func updateKey(with value: Any) -> String? {
        if let string = String.toString(value) {
            if let date = value as? Date, let newString = String.toString(date) {
                return newString.clean(maxCharacters: 100)
            } else if let array = value as? [Any] {
                if let newString = String.toString(array) {
                    return newString.clean(maxCharacters: 100)
                } else {
                    return nil
                }
            }
        }
        return nil
    }
}

// MARK: - String Extension

fileprivate extension String {
    private func clipped(maxCharacters: Int) -> String {
        String(prefix(maxCharacters))
    }

    private func replaceSpacesWithUnderscores() -> String {
        self.replacingOccurrences(of: " ", with: "_")
    }

    func clean(maxCharacters: Int) -> String {
        self
            .clipped(maxCharacters: maxCharacters)
            .replaceSpacesWithUnderscores()
    }
}

extension Dictionary where Key == String {
    mutating func first(upTo maxItems: Int) {
        var counter: Int = 0
        for (key, _) in self {
            if counter >= maxItems {
                removeValue(forKey: key)
            } else {
                counter += 1
            }
        }
    }
}
