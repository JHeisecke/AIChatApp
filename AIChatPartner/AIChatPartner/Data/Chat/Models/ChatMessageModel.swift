//
//  ChatMessageModel.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-15.
//

import Foundation

struct ChatMessageModel: Identifiable, Codable {
    let id: String
    let chatId: String
    let authorId: String?
    let content: AIChatModel?
    let seenByIds: [String]?
    let dateCreated: Date?

    init(
        id: String,
        chatId: String,
        authorId: String? = nil,
        content: AIChatModel? = nil,
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

    enum CodingKeys: String, CodingKey {
        case id
        case chatId = "chat_id"
        case authorId = "author_id"
        case content
        case seenByIds = "seen_by_ids"
        case dateCreated = "date_created"
    }

    func hasBeenSeenBy(userId: String) -> Bool {
        guard let seenByIds else { return false }
        return seenByIds.contains(userId)
    }
}

// MARK: - Builders

extension ChatMessageModel {
    static func newUserMessage(chatId: String, userId: String, message: AIChatModel) -> Self {
        ChatMessageModel(
            id: UUID().uuidString,
            chatId: chatId,
            authorId: userId,
            content: message,
            seenByIds: [userId],
            dateCreated: .now
        )
    }

    static func newAIMessage(chatId: String, avatarId: String, message: AIChatModel) -> Self {
        ChatMessageModel(
            id: UUID().uuidString,
            chatId: chatId,
            authorId: avatarId,
            content: message,
            seenByIds: [],
            dateCreated: .now
        )
    }
}

// MARK: - Mocks

extension ChatMessageModel {

    static var mock: ChatMessageModel {
        mocks[0]
    }

    static var mocks: [ChatMessageModel] {
        return [
            ChatMessageModel(
                id: "msg1",
                chatId: "1",
                authorId: UserAuthInfo.mock().uid,
                content: AIChatModel(role: .user, message: "Hello, how are you?"),
                seenByIds: [UserAuthInfo.mock().uid],
                dateCreated: Date.now
            ),
            ChatMessageModel(
                id: "msg2",
                chatId: "1",
                authorId: AvatarModel.mock.avatarId,
                content: AIChatModel(role: .assistant, message: "I'm doing well, thanks for asking!"),
                seenByIds: [UserAuthInfo.mock().uid],
                dateCreated: Date.now(days: -5)
            ),
            ChatMessageModel(
                id: "msg3",
                chatId: "1",
                authorId: UserAuthInfo.mock().uid,
                content: AIChatModel(role: .assistant, message: "Anyone up for a game tonight?"),
                seenByIds: [UserAuthInfo.mock().uid],
                dateCreated: Date.now(hours: -1)
            ),
            ChatMessageModel(
                id: "msg4",
                chatId: "1",
                authorId: AvatarModel.mock.avatarId,
                content: AIChatModel(role: .user, message: "Sure, count me in!"),
                seenByIds: [],
                dateCreated: Date.now(hours: -2)
            )
        ]
    }
}
