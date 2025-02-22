//
//  FirebaseAvatarService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-19.
//

import SwiftUI
import FirebaseFirestore

struct FirebaseAvatarService: AvatarService {

    var collection: CollectionReference {
        Firestore.firestore().collection("users")
    }

    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        
        let path = "avatars/\(avatar.avatarId)"
        let url = try await FirebaseImageUploadService().uploadImage(image: image, path: path)

        var avatar = avatar
        avatar.updateProfileImage(imageName: url.absoluteString)

        try collection.document(avatar.avatarId).setData(from: avatar, merge: true)
    }
}
