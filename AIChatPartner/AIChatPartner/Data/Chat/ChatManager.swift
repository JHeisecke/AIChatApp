//
//  ChatManager.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-25.
//

import Foundation

@MainActor
@Observable
class ChatManager {
    let service: ChatService

    init(service: ChatService) {
        self.service = service
    }

    func createNewChat(chat: ChatModel) async throws {
        try await service.createNewChat(chat: chat)
    }

    func getChat(userId: String, avatarId: String) async throws -> ChatModel? {
        return try await service.getChat(userId: userId, avatarId: avatarId)
    }

    func addChatMessage(message: ChatMessageModel) async throws {
        try await service.addChatMessage(message: message)
    }

    func streamChatMessages(chatId: String) -> AsyncThrowingStream<[ChatMessageModel], Error> {
        service.streamChatMessages(chatId: chatId)
    }
}
