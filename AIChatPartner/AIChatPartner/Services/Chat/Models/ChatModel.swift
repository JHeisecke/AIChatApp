//
//  ChatModel.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-15.
//

import Foundation

struct ChatModel: Identifiable, Hashable {
    let id: String
    let userId: String
    let avatarId: String
    let dateCreated: Date
    let dateModified: Date
}

// MARK: - Mocks

extension ChatModel {
    static var mock: ChatModel {
        mocks[0]
    }

    static var mocks: [ChatModel] {
        [
            ChatModel(
                id: "mock-1",
                userId: "user1",
                avatarId: "avatar1",
                dateCreated: Date.now(days: -1, hours: 0),
                dateModified: Date.now(hours: -12)
            ),
            ChatModel(
                id: "mock-2",
                userId: "user2",
                avatarId: "avatar2",
                dateCreated: Date.now(days: -2, hours: 0),
                dateModified: Date.now(hours: -18)
            ),
            ChatModel(
                id: "mock-3",
                userId: "user3",
                avatarId: "avatar3",
                dateCreated: Date.now(days: -3, hours: 0),
                dateModified: Date.now(hours: -24)
            ),
            ChatModel(
                id: "mock-4",
                userId: "user4",
                avatarId: "avatar4",
                dateCreated: Date.now(days: -4, hours: 0),
                dateModified: Date.now(hours: -30)
            )
        ]
    }
}
