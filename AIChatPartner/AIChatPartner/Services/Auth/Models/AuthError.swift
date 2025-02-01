//
//  AuthError.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-01.
//

import Foundation

enum AuthError: LocalizedError {
    case userNotFound

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "Current authenticated user not found."
        }
    }
}
