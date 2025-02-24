//
//  AIManager.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-19.
//

import SwiftUI

@MainActor
@Observable
class AvatarManager {
    private let remote: RemoteAvatarService
    private let local: LocalAvatarPersistence

    init(service: RemoteAvatarService, local: LocalAvatarPersistence = MockLocalAvatarPersistance()) {
        self.remote = service
        self.local = local
    }

    // MARK: - Local

    func addRecentAvatar(avatar: AvatarModel) async throws {
        try local.addRecentAvatar(avatar: avatar)
        try await remote.incrementAvatarClickCount(avatarId: avatar.avatarId)
    }

    func getRecentAvatar() throws -> [AvatarModel] {
        try local.getRecentAvatar()
    }

    // MARK: - Remote

    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        try await remote.createAvatar(avatar: avatar, image: image)
    }

    func getFeaturedAvatars() async throws -> [AvatarModel] {
        try await remote.getFeaturedAvatars()
    }

    func getPopularAvatars() async throws -> [AvatarModel] {
        try await remote.getPopularAvatars()
    }

    func getAvatars(by category: CharacterOption) async throws -> [AvatarModel] {
        try await remote.getAvatars(by: category)
    }

    func getAvatars(byAuthor id: String) async throws -> [AvatarModel] {
        try await remote.getAvatars(byAuthor: id)
    }

    func getAvatar(id: String) async throws -> AvatarModel {
        try await remote.getAvatar(id: id)
    }

    func removeAuthorIdFromAvatar(avatarId: String) async throws {
        try await remote.removeAuthorIdFromAvatar(avatarId: avatarId)
    }

    func removeAuthorIdFromAllUserAvatars(authorId: String) async throws {
        try await remote.removeAuthorIdFromAllUserAvatars(authorId: authorId)
    }
}
