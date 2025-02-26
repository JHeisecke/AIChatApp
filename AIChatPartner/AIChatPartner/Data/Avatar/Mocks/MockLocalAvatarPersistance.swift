//
//  MockLocalAvatarPersistance.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-22.
//

struct MockLocalAvatarPersistance: LocalAvatarPersistence {

    let avatars: [AvatarModel]

    init(avatars: [AvatarModel] = AvatarModel.mocks) {
        self.avatars = avatars
    }

    func addRecentAvatar(avatar: AvatarModel) throws {

    }

    func getRecentAvatar() throws -> [AvatarModel] {
        return avatars
    }
}
