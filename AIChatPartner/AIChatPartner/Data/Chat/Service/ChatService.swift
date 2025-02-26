//
//  ChatService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-25.
//

import Foundation

protocol ChatService: Sendable {
    func createNewChat(chat: ChatModel) async throws
    func getChat(userId: String, avatarId: String) async throws -> ChatModel?
    func streamChatMessages(chatId: String) -> AsyncThrowingStream<[ChatMessageModel], Error>
    func addChatMessage(message: ChatMessageModel) async throws
}
