//
//  TextValidationHelper.swift
//  AIChatCourse
//
//  Created by Javier Heisecke on 2025-01-17.
//
import Foundation

struct TextValidationHelper {
    
    static func checkIfTextIsValid(text: String, minCharactersLength: Int = 1) throws {
        let badWords: [String] = [
            "shit", "bitch", "ass"
        ]

        if text.count < minCharactersLength {
            throw TextValidationError.notLongEnough(minLength: minCharactersLength)
        }

        if badWords.contains(text.lowercased()) {
            throw TextValidationError.hasBadWords
        }
    }

    enum TextValidationError: LocalizedError {
        case hasBadWords
        case notLongEnough(minLength: Int)

        var errorDescription: String? {
            switch self {
            case .hasBadWords:
                return "Bad word detected. Please rephrase your message."
            case .notLongEnough(let minLength):
                return "The text should have at least \(minLength) character/s"
            }
        }
    }
}
