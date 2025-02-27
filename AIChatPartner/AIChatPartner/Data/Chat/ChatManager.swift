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

    func getAllChats(userId: String) async throws -> [ChatModel] {
        try await service.getAllChats(userId: userId)
    }

    func getChat(userId: String, avatarId: String) async throws -> ChatModel? {
        try await service.getChat(userId: userId, avatarId: avatarId)
    }

    func getLastChatMessage(chatId: String) async throws -> ChatMessageModel? {
        try await service.getLastChatMessage(chatId: chatId)
    }

    func addChatMessage(message: ChatMessageModel) async throws {
        try await service.addChatMessage(message: message)
    }

    func streamChatMessages(chatId: String) -> AsyncThrowingStream<[ChatMessageModel], Error> {
        service.streamChatMessages(chatId: chatId)
    }

    func deleteChat(chatId: String) async throws {
        try await service.deleteChat(chatId: chatId)
    }

    func deleteAllChatsForUser(userId: String) async throws {
        try await service.deleteAllChatsForUser(userId: userId)
    }

    func reportChat(chatId: String, reportingUserId: String, reportedAvatarId: String) throws {
        try service.reportChat(report: ChatReportModel.new(chatId: chatId, reportedAvatarId: reportedAvatarId, reportingUserId: reportingUserId))
    }
}
