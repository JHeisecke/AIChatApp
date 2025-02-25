//
//  ChatManager.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-25.
//

import Foundation

protocol ChatService: Sendable {
    func createNewChat(chat: ChatModel) async throws
}

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
}

import FirebaseFirestore

struct FirebaseChatService: ChatService {

    var collection: CollectionReference {
        Firestore.firestore().collection("chats")
    }

    func createNewChat(chat: ChatModel) async throws {
        do {
            try collection.document(chat.id).setData(from: chat, merge: true)
        } catch {
            throw ChatError.chatCreation
        }
    }
}

struct MockChatService: ChatService {
    func createNewChat(chat: ChatModel) async throws {
        
    }
}
