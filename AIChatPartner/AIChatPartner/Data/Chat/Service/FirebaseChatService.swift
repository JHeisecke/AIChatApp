//
//  FirebaseChatService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-25.
//

import Foundation
import FirebaseFirestore

struct FirebaseChatService: ChatService {

    private var collection: CollectionReference {
        Firestore.firestore().collection("chats")
    }

    private func messagesCollection(chatId: String) -> CollectionReference {
        collection.document(chatId).collection("messages")
    }

    func createNewChat(chat: ChatModel) async throws {
        do {
            try collection.document(chat.id).setData(from: chat, merge: true)
        } catch {
            throw ChatError.chatCreation
        }
    }

    func addChatMessage(message: ChatMessageModel) async throws {
        try messagesCollection(chatId: message.chatId).document(message.id).setData(from: message, merge: true)
        try await updateChat(message.chatId, values: [
            ChatModel.CodingKeys.dateModified.rawValue: Date.now
        ])
    }

    private func updateChat(_ id: String, values: [String:Any]) async throws {
        try await collection.document(id).updateData(values)
    }
}
