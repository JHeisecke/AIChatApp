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
