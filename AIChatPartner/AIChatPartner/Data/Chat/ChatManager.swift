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

    func addChatMessage(message: ChatMessageModel) async throws {
        try await service.addChatMessage(message: message)
    }
}
