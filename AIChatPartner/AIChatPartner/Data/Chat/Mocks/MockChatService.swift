//
//  MockChatService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-25.
//

struct MockChatService: ChatService {

    let messages: [ChatMessageModel]

    init(messages: [ChatMessageModel] = []) {
        self.messages = messages
    }

    func createNewChat(chat: ChatModel) async throws {
        
    }

    func getChat(userId: String, avatarId: String) async throws -> ChatModel? {
        return .mock
    }

    func streamChatMessages(chatId: String) -> AsyncThrowingStream<[ChatMessageModel], Error> {
        AsyncThrowingStream { continuation in
            continuation.yield(messages)
        }
    }

    func addChatMessage(message: ChatMessageModel) async throws {
        
    }
}
