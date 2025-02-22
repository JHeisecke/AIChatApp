//
//  MockLocalAvatarPersistance.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-22.
//

struct MockLocalAvatarPersistance: LocalAvatarPersistence {

    func addRecentAvatar(avatar: AvatarModel) throws {

    }

    func getRecentAvatar() throws -> [AvatarModel] {
        return AvatarModel.mocks.shuffled()
    }
}
