//
//  CharacterOption.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-16.
//

import Foundation

// MARK: - CharacterOption

enum CharacterOption: String, CaseIterable, Hashable, Codable {
    case man, woman, alien, dog, cat

    static var `default`: Self {
        .man
    }

    var startsWithVowel: Bool {
        switch self {
        case .alien:
            true
        default:
            false
        }
    }

    var plural: String {
        switch self {
        case .man:
            return "men"
        case .woman:
            return "women"
        case .alien:
            return "aliens"
        case .dog:
            return "dogs"
        case .cat:
            return "cat"
        }
    }
}

// MARK: - CharacterAction

enum CharacterAction: String, CaseIterable, Hashable, Codable {
    case smiling, sitting, eating, drinking, walking, shopping, studying, working, relaxing, fighting, crying

    static var `default`: Self {
        .smiling
    }
}

// MARK: - CharacterLocation

enum CharacterLocation: String, CaseIterable, Hashable, Codable {
    case park, mall, museum, city, desert, forest, space

    static var `default`: Self {
        .park
    }
}

// MARK: - AvatarDescriptionBuilder

struct AvatarDescriptionBuilder {
    let characterOption: CharacterOption
    let characterAction: CharacterAction
    let characterLocation: CharacterLocation

    init(characterOption: CharacterOption, characterAction: CharacterAction, characterLocation: CharacterLocation) {
        self.characterOption = characterOption
        self.characterAction = characterAction
        self.characterLocation = characterLocation
    }

    init(avatar: AvatarModel) {
        self.characterOption = avatar.characterOption ?? .default
        self.characterAction = avatar.characterAction ?? .default
        self.characterLocation = avatar.characterLocation ?? .default
    }

    var characterDescription: String {
        let prefix = characterOption.startsWithVowel ? "An" : "A"
        return "\(prefix) \(characterOption.rawValue) that is \(characterAction.rawValue) in the \(characterLocation.rawValue)"
    }
}
