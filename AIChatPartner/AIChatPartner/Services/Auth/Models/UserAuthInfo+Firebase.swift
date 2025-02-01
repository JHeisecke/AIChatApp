//
//  UserAuthInfo+Firebase.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-01.
//

import FirebaseAuth
import Foundation

extension UserAuthInfo {
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.isAnonymous = user.isAnonymous
        self.creationDate = user.metadata.creationDate
        self.lastSignInDate = user.metadata.lastSignInDate
    }
}
