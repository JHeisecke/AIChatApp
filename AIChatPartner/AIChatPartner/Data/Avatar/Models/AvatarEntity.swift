//
//  AvatarEntity.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-22.
//

import SwiftData
import Foundation

@Model
class AvatarEntity {
    @Attribute(.unique) var avatarId: String
    var name: String?
    var profileImageName: String?
    var characterOption: CharacterOption?
    var characterAction: CharacterAction?
    var characterLocation: CharacterLocation?
    var authorId: String?
    var dateCreated: Date?
    var dateAdded: Date

    init(from model: AvatarModel) {
        self.avatarId = model.avatarId
        self.name = model.name
        self.profileImageName = model.profileImageName
        self.characterAction = model.characterAction
        self.characterOption = model.characterOption
        self.characterLocation = model.characterLocation
        self.authorId = model.authorId
        self.dateCreated = model.dateCreated
        self.dateAdded = .now
    }
}

// MARK: - To Model

extension AvatarEntity {
    func toModel() -> AvatarModel {
        AvatarModel(
            avatarId: self.avatarId,
            name: self.name,
            profileImageName: self.profileImageName,
            characterOption: self.characterOption,
            characterAction: self.characterAction,
            characterLocation: self.characterLocation,
            authorId: self.authorId,
            dateCreated: self.dateCreated
        )
    }
}
