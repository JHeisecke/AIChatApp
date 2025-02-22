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
            .limit(to: 200)
            .getDocuments(as: AvatarModel.self)
    }

    func getAvatars(by category: CharacterOption) async throws -> [AvatarModel] {
        try await collection
            .whereField(AvatarModel.CodingKeys.characterOption.rawValue, isEqualTo: category.rawValue)
            .limit(to: 200)
            .getDocuments(as: AvatarModel.self)
    }

    func getAvatars(by author: String) async throws -> [AvatarModel] {
        try await collection
            .whereField(AvatarModel.CodingKeys.authorId.rawValue, isEqualTo: author)
            .getDocuments(as: AvatarModel.self)
    }

    func getAvatar(id: String) async throws -> AvatarModel {
        try await collection.document(id).getDocument(as: AvatarModel.self)
    }
}
