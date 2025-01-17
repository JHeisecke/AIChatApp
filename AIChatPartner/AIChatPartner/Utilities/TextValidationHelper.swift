//
//  TextValidationHelper.swift
//  AIChatCourse
//
//  Created by Javier Heisecke on 2025-01-17.
//
import Foundation

struct TextValidationHelper {
    
    static func checkIfTextIsValid(text: String) throws {
        let badWords: [String] = [
            "shit", "bitch", "ass"
        ]
        
        if badWords.contains(text.lowercased()) {
            throw TextValidationError.hasBadWords
        }
    }

    enum TextValidationError: LocalizedError {
        case hasBadWords
        
        var errorDescription: String? {
            switch self {
            case .hasBadWords:
                return "Bad word detected. Please rephrase your message."
            }
        }
    }
}
