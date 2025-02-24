//
//  FirebaseAvatarService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-19.
//

import SwiftUI
import FirebaseFirestore

struct FirebaseAvatarService: RemoteAvatarService {

    var collection: CollectionReference {
        Firestore.firestore().collection("avatars")
    }

    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        
        let path = "avatars/\(avatar.avatarId)"
        let url = try await FirebaseImageUploadService().uploadImage(image: image, path: path)

        var avatar = avatar
        avatar.updateProfileImage(imageName: url.absoluteString)

        try collection.document(avatar.avatarId).setData(from: avatar, merge: true)
    }

    func getFeaturedAvatars() async throws -> [AvatarModel] {
        try await collection
            .limit(to: 50)
            .getDocuments(as: AvatarModel.self)
            .shuffled()
            .first(upTo: 5) ?? []
    }

    func getPopularAvatars() async throws -> [AvatarModel] {
        try await collection
            .order(by: AvatarModel.CodingKeys.clickCount.rawValue, descending: true)
            .getDocuments(as: AvatarModel.self)
    }

    func getAvatars(by category: CharacterOption) async throws -> [AvatarModel] {
        try await collection
            .whereField(AvatarModel.CodingKeys.characterOption.rawValue, isEqualTo: category.rawValue)
            .limit(to: 200)
            .getDocuments(as: AvatarModel.self)
    }

    func getAvatars(byAuthor id: String) async throws -> [AvatarModel] {
        try await collection
            .whereField(AvatarModel.CodingKeys.authorId.rawValue, isEqualTo: id)
            .order(by: AvatarModel.CodingKeys.dateCreated.rawValue, descending: true)
            .getDocuments(as: AvatarModel.self)
    }

    func getAvatar(id: String) async throws -> AvatarModel {
        try await collection.document(id).getDocument(as: AvatarModel.self)
    }

    func removeAuthorIdFromAvatar(avatarId: String) async throws {
        try await collection.document(avatarId).updateData([
            AvatarModel.CodingKeys.authorId.rawValue: NSNull()
        ])
    }

    func removeAuthorIdFromAllUserAvatars(authorId: String) async throws {
        let avatars = try await getAvatars(byAuthor: authorId)

        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                for avatar in avatars {
                    try await removeAuthorIdFromAvatar(avatarId: avatar.avatarId)
                }
            }

            try await group.waitForAll()
        }
    }

    func incrementAvatarClickCount(avatarId: String) async throws {
        try await collection.document(avatarId).updateData([
            AvatarModel.CodingKeys.clickCount.rawValue: FieldValue.increment(Int64(1))
        ])
    }
}
