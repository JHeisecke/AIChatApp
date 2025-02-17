//
//  UserService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-17.
//

import SwiftUI
import FirebaseFirestore

protocol UserService: Sendable {
    func saveUser(user: UserModel) async throws
    func deleteUser(userId: String) async throws
    func markOnboardingAsCompleted(userId: String, profileColorHex: String) async throws
    func streamUser(userId: String) -> AsyncThrowingStream<UserModel, Error>
}

struct FirebaseUserService: UserService {
    var collection: CollectionReference {
        Firestore.firestore().collection("users")
    }

    func saveUser(user: UserModel) async throws {
        try collection.document(user.userId).setData(from: user, merge: true)
    }

    func markOnboardingAsCompleted(userId: String, profileColorHex: String) async throws {
        try await collection.document(userId).updateData([
            UserModel.CodingKeys.didCompleteOnboarding.rawValue: true,
            UserModel.CodingKeys.profileColor.rawValue: profileColorHex
        ])
    }

    func streamUser(userId: String) -> AsyncThrowingStream<UserModel, Error> {
        AsyncThrowingStream(UserModel.self) { continuation in
            _ = collection.document(userId).addSnapshotListener { document, error in
                if let error {
                    continuation.finish(throwing: error)
                    return
                }
                guard let document else {
                    continuation.finish(throwing: UserManagerError.userNotFound(id: userId))
                    return
                }
                do {
                    let model = try document.data(as: UserModel.self)
                    continuation.yield(model)
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    func deleteUser(userId: String) async throws {
        try await collection.document(userId).delete()
    }
}
