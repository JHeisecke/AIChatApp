//
//  ChatMessageModel.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-15.
//

import Foundation

struct ChatMessageModel {
    let id: String
    let chatId: String
    let authorId: String?
    let content: String?
    let seenByIds: [String]?
    let dateCreated: Date?

    init(
        id: String,
        chatId: String,
        authorId: String? = nil,
        content: String? = nil,
        seenByIds: [String]? = nil,
        dateCreated: Date? = nil
    ) {
        self.id = id
        self.chatId = chatId
        self.authorId = authorId
        self.content = content
        self.seenByIds = seenByIds
        self.dateCreated = dateCreated
    }

    func hasBeenSeenBy(userId: String) -> Bool {
        guard let seenByIds else { return false }
        return seenByIds.contains(userId)
    }
}

// MARK: - Mocks

extension ChatMessageModel {
    static var mock: ChatMessageModel {
        mocks[0]
    }

    static var mocks: [ChatMessageModel] {
        [
            ChatMessageModel(
                id: "msg1",
                chatId: "chat1",
                authorId: "user1",
                content: "Hello, how are you?",
                seenByIds: ["user2", "user3"],
                dateCreated: Date.now(hours: -1)
            ),
            ChatMessageModel(
                id: "msg2",
                chatId: "chat1",
                authorId: "user2",
                content: "I'm fine, thanks! How about you?",
                seenByIds: ["user1", "user3"],
                dateCreated: Date.now(hours: -2)
            ),
            ChatMessageModel(
                id: "msg3",
                chatId: "chat2",
                authorId: "user3",
                content: "Hey, are we still meeting later?",
                seenByIds: ["user1"],
                dateCreated: Date.now(hours: -3)
            ),
            ChatMessageModel(
                id: "msg4",
                chatId: "chat2",
                authorId: "user1",
                content: "Yes, see you at 6 PM.",
                seenByIds: nil,
                dateCreated: Date.now(hours: -4)
            )
        ]
    }
}
