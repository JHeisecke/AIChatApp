//
//  ChatError.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-25.
//

import Foundation

enum ChatError: LocalizedError {
    case chatCreation
    case chatNotFound

    var errorDescription: String? {
        switch self {
        case .chatCreation:
            "There was an error creating the chat.\nTry again later."
        case .chatNotFound:
            "Chat not found."
        }
    }
}
