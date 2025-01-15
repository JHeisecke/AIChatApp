//
//  AvatarModel.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-11.
//
/// https://www.youtube.com/watch?v=wSmTbtOwgbE&list=PLwvDm4Vfkdphr2Dl4sY4rS9PLzPdyi8PM&index=14&t=4s

import Foundation

struct AvatarModel: Hashable {

    let avatarId: String
    let name: String?
    let profileImageName: String?
    let characterOption: CharacterOption?
    let characterAction: CharacterAction?
    let characterLocation: CharacterLocation?
    let authorId: String?
    let dateCreated: Date?

    init(
        avatarId: String,
        name: String? = nil,
        profileImageName: String? = nil,
        characterOption: CharacterOption? = nil,
        characterAction: CharacterAction? = nil,
        characterLocation: CharacterLocation? = nil,
        authorId: String? = nil,
        dateCreated: Date? = nil
    ) {
        self.avatarId = avatarId
        self.name = name
        self.profileImageName = profileImageName
        self.characterOption = characterOption
        self.characterAction = characterAction
        self.characterLocation = characterLocation
        self.authorId = authorId
        self.dateCreated = dateCreated
    }

    var characterDescription: String {
        AvatarDescriptionBuilder(avatar: self).characterDescription
    }
}

// MARK: - CharacterOption

enum CharacterOption: String, CaseIterable, Hashable {
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
}

// MARK: - CharacterAction

enum CharacterAction: String {
    case smiling, sitting, eating, drinking, walking, shopping, studying, working, relaxing, fighting, crying

    static var `default`: Self {
        .smiling
    }
}

// MARK: - CharacterLocation

enum CharacterLocation: String {
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

// MARK: - Mocks

extension AvatarModel {
    static var mocks: [AvatarModel] {
        [
            AvatarModel(
                avatarId: UUID().uuidString,
                name: "Alpha",
                profileImageName: Constants.randomImage,
                characterOption: .woman,
                characterAction: .crying,
                characterLocation: .city,
                authorId: UUID().uuidString,
                dateCreated: .now
            ),
            AvatarModel(
                avatarId: UUID().uuidString,
                name: "Beta",
                profileImageName: Constants.randomImage,
                characterOption: .man,
                characterAction: .smiling,
                characterLocation: .forest,
                authorId: UUID().uuidString,
                dateCreated: .now
            ),
            AvatarModel(
                avatarId: UUID().uuidString,
                name: "Gamma",
                profileImageName: Constants.randomImage,
                characterOption: .dog,
                characterAction: .sitting,
                characterLocation: .space,
                authorId: UUID().uuidString,
                dateCreated: .now
            ),
            AvatarModel(
                avatarId: UUID().uuidString,
                name: "Delta",
                profileImageName: Constants.randomImage,
                characterOption: .cat,
                characterAction: .drinking,
                characterLocation: .mall,
                authorId: UUID().uuidString,
                dateCreated: .now
            )
        ]
    }
    
    static var mock: AvatarModel {
        AvatarModel(
            avatarId: UUID().uuidString,
            name: "Alpha",
            profileImageName: Constants.randomImage,
            characterOption: .woman,
            characterAction: .crying,
            characterLocation: .city,
            authorId: UUID().uuidString,
            dateCreated: .now
        )
    }
}
