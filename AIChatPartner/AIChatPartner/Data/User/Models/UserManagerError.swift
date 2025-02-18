//
//  UserManagerError.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-17.
//

import Foundation

enum UserManagerError: LocalizedError {
    case noUserId
    case userNotFound(id: String)

    var errorDescription: String? {
        switch self {
        case .noUserId:
            "The current user doesn't have an id."
        case .userNotFound(let id):
            "No user was found with the id \(id)."
        }
    }
}
