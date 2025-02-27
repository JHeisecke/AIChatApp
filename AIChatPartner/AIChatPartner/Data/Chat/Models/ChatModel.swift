//
//  ChatModel.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-15.
//

import Foundation

struct ChatModel: Identifiable, Hashable, Codable {
    let id: String
    let userId: String
    let avatarId: String
    let dateCreated: Date
    let dateModified: Date

    static func chatId(userId: String, avatarId: String) -> String {
        "\(userId)_\(avatarId)"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case avatarId = "avatar_id"
        case dateCreated = "date_created"
        case dateModified = "date_modified"
    }

    static func new(userId: String, avatarId: String) -> Self {
        ChatModel(
            id: ChatModel.chatId(userId: userId, avatarId: avatarId),
            userId: userId,
            avatarId: avatarId,
            dateCreated: .now,
            dateModified: .now
        )
    }
}

// MARK: - Mocks

extension ChatModel {
    static var mock: Self {
        mocks[0]
    }

    static var mocks: [Self] {
        [
            ChatModel(
                id: ChatModel.chatId(userId: UserAuthInfo.mock().uid, avatarId: AvatarModel.mock.avatarId),
                userId: UserAuthInfo.mock().uid,
                avatarId: AvatarModel.mock.avatarId,
                dateCreated: Date.now(days: -1, hours: 0),
                dateModified: Date.now(hours: -12)
            ),
            ChatModel(
                id: ChatModel.chatId(userId: UserAuthInfo.mock().uid, avatarId: AvatarModel.mocks.last!.avatarId),
                userId: UserAuthInfo.mock().uid,
                avatarId: AvatarModel.mocks.last!.avatarId,
                dateCreated: Date.now(days: -2, hours: 0),
                dateModified: Date.now(hours: -18)
            ),
            ChatModel(
                id: ChatModel.chatId(userId: UserAuthInfo.mock().uid, avatarId: AvatarModel.mocks[2].avatarId),
                userId: UserAuthInfo.mock().uid,
                avatarId: AvatarModel.mocks[2].avatarId,
                dateCreated: Date.now(days: -3, hours: 0),
                dateModified: Date.now(hours: -24)
            ),
            ChatModel(
                id: ChatModel.chatId(userId: UserAuthInfo.mock().uid, avatarId: AvatarModel.mocks[3].avatarId),
                userId: UserAuthInfo.mock().uid,
                avatarId: AvatarModel.mocks[3].avatarId,
                dateCreated: Date.now(days: -4, hours: 0),
                dateModified: Date.now(hours: -30)
            )
        ]
    }
}
