//
//  LocalUserPersistance.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-17.
//

protocol LocalUserPersistance {
    func getCurrentUser() -> UserModel?
    func saveCurrentUser(user: UserModel?) throws
}
