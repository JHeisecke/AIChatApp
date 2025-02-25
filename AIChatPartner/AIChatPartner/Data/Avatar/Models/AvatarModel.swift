//
//  AvatarModel.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-11.
//
/// https://www.youtube.com/watch?v=wSmTbtOwgbE&list=PLwvDm4Vfkdphr2Dl4sY4rS9PLzPdyi8PM&index=14&t=4s

import Foundation

struct AvatarModel: Hashable, Codable {

    let avatarId: String
    let name: String?
    private(set) var profileImageName: String?
    let characterOption: CharacterOption?
    let characterAction: CharacterAction?
    let characterLocation: CharacterLocation?
    let authorId: String?
    let dateCreated: Date?
    let clickCount: Int?

    init(
        avatarId: String,
        name: String? = nil,
        profileImageName: String? = nil,
        characterOption: CharacterOption? = nil,
        characterAction: CharacterAction? = nil,
        characterLocation: CharacterLocation? = nil,
        authorId: String? = nil,
        dateCreated: Date? = nil,
        clickCount: Int? = 0
    ) {
        self.avatarId = avatarId
        self.name = name
        self.profileImageName = profileImageName
        self.characterOption = characterOption
        self.characterAction = characterAction
        self.characterLocation = characterLocation
        self.authorId = authorId
        self.dateCreated = dateCreated
        self.clickCount = clickCount
    }

    enum CodingKeys: String, CodingKey {
        case avatarId = "avatar_id"
        case name
        case profileImageName = "profile_image_name"
        case characterOption = "character_option"
        case characterAction = "character_action"
        case characterLocation = "character_location"
        case authorId = "author_id"
        case dateCreated = "date_created"
        case clickCount = "click_count"
    }

    var characterDescription: String {
        AvatarDescriptionBuilder(avatar: self).characterDescription
    }

    mutating func updateProfileImage(imageName: String) {
        profileImageName = imageName
    }

    static func newAvatar(name: String, option: CharacterOption, action: CharacterAction, location: CharacterLocation, authorId: String) -> Self {
        AvatarModel(
            avatarId: UUID().uuidString,
            name: name,
            profileImageName: nil,
            characterOption: option,
            characterAction: action,
            characterLocation: location,
            authorId: authorId,
            dateCreated: .now
        )
    }
}

// MARK: - Mocks

extension AvatarModel {
    static var mocks: [AvatarModel] {
        [
            AvatarModel(
                avatarId: "mock_ava_1",
                name: "Alpha",
                profileImageName: Constants.randomImage,
                characterOption: .woman,
                characterAction: .crying,
                characterLocation: .city,
                authorId: UserAuthInfo.mock().uid,
                dateCreated: .now,
                clickCount: 10
            ),
            AvatarModel(
                avatarId: "mock_ava_2",
                name: "Beta",
                profileImageName: Constants.randomImage,
                characterOption: .man,
                characterAction: .smiling,
                characterLocation: .forest,
                authorId: UserAuthInfo.mock().uid,
                dateCreated: .now,
                clickCount: 100
            ),
            AvatarModel(
                avatarId: "mock_ava_3",
                name: "Gamma",
                profileImageName: Constants.randomImage,
                characterOption: .dog,
                characterAction: .sitting,
                characterLocation: .space,
                authorId: UUID().uuidString,
                dateCreated: .now,
                clickCount: 9
            ),
            AvatarModel(
                avatarId: "mock_ava_4",
                name: "Delta",
                profileImageName: Constants.randomImage,
                characterOption: .cat,
                characterAction: .drinking,
                characterLocation: .mall,
                authorId: UUID().uuidString,
                dateCreated: .now,
                clickCount: 7
            )
        ]
    }
    
    static var mock: AvatarModel {
        AvatarModel.mocks[0]
    }
}
