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

    private func reportsCollection(chatId: String) -> CollectionReference {
        collection.document(chatId).collection("chats_reports")
    }

    func createNewChat(chat: ChatModel) async throws {
        do {
            try collection.document(chat.id).setData(from: chat, merge: true)
        } catch {
            throw ChatError.chatCreation
        }
    }

    func getChat(userId: String, avatarId: String) async throws -> ChatModel? {
        return try await collection.document(ChatModel.chatId(userId: userId, avatarId: avatarId)).getDocument(as: ChatModel.self)
    }

    func getAllChats(userId: String) async throws -> [ChatModel] {
        return try await collection
            .whereField(ChatModel.CodingKeys.userId.rawValue, isEqualTo: userId)
            .getDocuments(as: ChatModel.self)
    }

    func addChatMessage(message: ChatMessageModel) async throws {
        try messagesCollection(chatId: message.chatId).document(message.id).setData(from: message, merge: true)
        try await updateChat(message.chatId, values: [
            ChatModel.CodingKeys.dateModified.rawValue: Date.now
        ])
    }

    func streamChatMessages(chatId: String) -> AsyncThrowingStream<[ChatMessageModel], Error> {
        AsyncThrowingStream([ChatMessageModel].self) { continuation in
            _ = messagesCollection(chatId: chatId).addSnapshotListener { querySnapshot, error in
                if let error {
                    continuation.finish(throwing: error)
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    continuation.finish(throwing: ChatError.chatNotFound)
                    return
                }
                do {
                    let models = try documents.compactMap({ try $0.data(as: ChatMessageModel.self) })
                    continuation.yield(models)
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    func getLastChatMessage(chatId: String) async throws -> ChatMessageModel? {
        try await messagesCollection(chatId: chatId)
            .order(by: ChatMessageModel.CodingKeys.dateCreated.rawValue, descending: true)
            .limit(to: 1)
            .getDocuments(as: ChatMessageModel.self)
            .first
    }

    func deleteChat(chatId: String) async throws {
        async let chatDeletion: Void = collection.document(chatId).delete()
        async let messagesDeletion: Void = messagesCollection(chatId: chatId).document().delete()

        let (_, _) = try (await chatDeletion, await messagesDeletion)
    }

    func deleteAllChatsForUser(userId: String) async throws {
        let allChats = try await getAllChats(userId: userId)
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                for chat in allChats {
                    try await deleteChat(chatId: chat.id)
                }
            }

            try await group.waitForAll()
        }
    }

    func reportChat(report: ChatReportModel)  throws {
        try reportsCollection(chatId: report.chatId).document(report.id).setData(from: report, merge: true)
    }

    func markChatMessageAsSeen(chatId: String, userId: String, messageId: String) async throws {
        try await messagesCollection(chatId: chatId).document(messageId).updateData([
            ChatMessageModel.CodingKeys.seenByIds.rawValue: FieldValue.arrayUnion([userId])
        ])
    }

    private func updateChat(_ id: String, values: [String: Any]) async throws {
        try await collection.document(id).updateData(values)
    }
}
