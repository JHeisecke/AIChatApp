//
//  MixpanelService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-03-19.
//

import Mixpanel

struct MixpanelService: LogService {

    private var instance: MixpanelInstance {
        Mixpanel.mainInstance()
    }

    init(token: String, loggingEnabled: Bool = false) {
        Mixpanel.initialize(token: token, trackAutomaticEvents: true)
        instance.loggingEnabled = true
    }

    func identifyUser(userId: String, email: String?) {
        instance.identify(distinctId: userId)
        if let email {
            instance.people.set(property: "$name", to: email)
        }
    }
    
    func addUserProperties(dict: [String : Any], isHighPriority: Bool) {
        var userProperties: [String: MixpanelType] = [:]
        for (key, value) in dict {
            if let value = value as? MixpanelType {
                userProperties[key] = value
            }
        }
        instance.people.set(properties: userProperties)
    }
    
    func deleteUserProfile() {
        instance.people.deleteUser()
    }
    
    func trackEvent(event: LoggableEvent) {
        var properties: [String: MixpanelType] = [:]
        if let parameters = event.parameters {
            for (key, value) in parameters {
                if let value = value as? MixpanelType {
                    properties[key] = value
                }
            }
        }
        instance.track(event: event.eventName, properties: properties.isEmpty ? nil: properties)
    }
    
    func trackScreenEvent(event: LoggableEvent) {
        trackEvent(event: event)
    }
    

}
