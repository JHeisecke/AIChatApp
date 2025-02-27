//
//  MockChatService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-25.
//

import Foundation

@MainActor
class MockChatService: ChatService {

    let chats: [ChatModel]
    @Published var messages: [ChatMessageModel]
    let delay: Double
    let showError: Bool

    init(chats: [ChatModel] = ChatModel.mocks, messages: [ChatMessageModel] = ChatMessageModel.mocks, delay: Double = 0.0, showError: Bool = false) {
        self.messages = messages
        self.chats = chats
        self.delay = delay
        self.showError = showError
    }

    private func tryShowError() throws {
        if showError {
            throw URLError(.unknown)
        }
    }

    func createNewChat(chat: ChatModel) async throws {
        
    }

    func getChat(userId: String, avatarId: String) async throws -> ChatModel? {
        guard let chat = chats.first(where: { $0.id == ChatModel.chatId(userId: userId, avatarId: avatarId) }) else { throw URLError(.noPermissionsToReadFile) }
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return chat
    }

    func getAllChats(userId: String) async throws -> [ChatModel] {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return chats
    }

    func streamChatMessages(chatId: String) -> AsyncThrowingStream<[ChatMessageModel], Error> {
        AsyncThrowingStream { continuation in
            continuation.yield(messages)

            Task {
                for await value in $messages.values {
                    continuation.yield(value)
                }
            }
        }
    }

    func addChatMessage(message: ChatMessageModel) async throws {
        messages.append(message)
    }

    func deleteChat(chatId: String) async throws {
    }

    func getLastChatMessage(chatId: String) async throws -> ChatMessageModel? {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return .mock
    }

    func deleteAllChatsForUser(userId: String) async throws {

    }

    func reportChat(report: ChatReportModel) throws {
        
    }

    func markChatMessageAsSeen(chatId: String, userId: String, messageId: String) async throws {
        
    }
}
