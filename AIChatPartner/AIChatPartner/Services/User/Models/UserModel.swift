//
//  UserModel.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-16.
//

import SwiftUI

struct UserModel: Codable {

    let userId: String
    let email: String?
    let isAnonymous: Bool?
    let creationDate: Date?
    let lastSignInDate: Date?
    let creationVersion: String?

    let didCompleteOnboarding: Bool?
    let profileColor: String?

    init(
        userId: String,
        email: String? = nil,
        isAnonymous: Bool? = nil,
        creationDate: Date? = nil,
        lastSignInDate: Date? = nil,
        creationVersion: String? = nil,
        didCompleteOnboarding: Bool? = nil,
        profileColor: String? = nil
    ) {
        self.userId = userId
        self.email = email
        self.isAnonymous = isAnonymous
        self.creationDate = creationDate
        self.lastSignInDate = lastSignInDate
        self.creationVersion = creationVersion
        self.didCompleteOnboarding = didCompleteOnboarding
        self.profileColor = profileColor
    }

    init(auth: UserAuthInfo, creationVersion: String?) {
        self.init(
            userId: auth.uid,
            email: auth.email,
            isAnonymous: auth.isAnonymous,
            creationDate: auth.creationDate,
            lastSignInDate: auth.lastSignInDate,
            creationVersion: creationVersion
        )
    }

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case isAnonymous = "is_anonymous"
        case creationDate = "creation_date"
        case lastSignInDate = "last_sign_in_date"
        case creationVersion = "creation_version"
        case didCompleteOnboarding = "did_complete_onboarding"
        case profileColor = "profile_color"
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
                creationDate: Date.now(hours: -1),
                didCompleteOnboarding: true,
                profileColor: "#FF0000"
            ),
            UserModel(
                userId: "user_002",
                creationDate: Date.now(hours: -4),
                didCompleteOnboarding: false,
                profileColor: "#00FF00"
            ),
            UserModel(
                userId: "user_003",
                creationDate: nil,
                didCompleteOnboarding: nil,
                profileColor: nil
            ),
            UserModel(
                userId: "user_004",
                creationDate: Date.now,
                didCompleteOnboarding: true,
                profileColor: nil
            ),
            UserModel(
                userId: "user_005",
                creationDate: Date.now(days: -1),
                didCompleteOnboarding: nil,
                profileColor: "#0000FF"
            )
        ]
    }
}
