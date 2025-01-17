//
//  UserModel.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-16.
//

import SwiftUI

struct UserModel {

    let userId: String
    let dateCreated: Date?
    let didCompleteOnboarding: Bool?
    let profileColor: String?

    init(
        userId: String,
        dateCreated: Date? = nil,
        didCompleteOnboarding: Bool? = nil,
        profileColor: String?  = nil
    ) {
        self.userId = userId
        self.dateCreated = dateCreated
        self.didCompleteOnboarding = didCompleteOnboarding
        self.profileColor = profileColor
    }

    var profileColorCalculated: Color {
        guard let profileColor else {
            return Color.accentColor
        }
        return Color(hex: profileColor)
    }
}

extension UserModel {
    static var mock: Self {
        mocks[0]
    }
    static var mocks: [Self] {
        [
            UserModel(
                userId: "user_001",
                dateCreated: Date.now(hours: -1),
                didCompleteOnboarding: true,
                profileColor: "#FF0000"
            ),
            UserModel(
                userId: "user_002",
                dateCreated: Date.now(hours: -4),
                didCompleteOnboarding: false,
                profileColor: "#00FF00"
            ),
            UserModel(
                userId: "user_003",
                dateCreated: nil,
                didCompleteOnboarding: nil,
                profileColor: nil
            ),
            UserModel(
                userId: "user_004",
                dateCreated: Date.now,
                didCompleteOnboarding: true,
                profileColor: nil
            ),
            UserModel(
                userId: "user_005",
                dateCreated: Date.now(days: -1),
                didCompleteOnboarding: nil,
                profileColor: "#0000FF"
            )
        ]
    }
}
