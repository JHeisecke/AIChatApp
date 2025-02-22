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
    private let service: AvatarService

    init(service: AvatarService) {
        self.service = service
    }

    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        try await service.createAvatar(avatar: avatar, image: image)
    }

    func getFeaturedAvatars() async throws -> [AvatarModel] {
        try await service.getFeaturedAvatars()
    }

    func getPopularAvatars() async throws -> [AvatarModel] {
        try await service.getPopularAvatars()
    }

    func getAvatars(by category: CharacterOption) async throws -> [AvatarModel] {
        try await service.getAvatars(by: category)
    }

    func getAvatars(byAuthor id: String) async throws -> [AvatarModel] {
        try await service.getAvatars(by: id)
    }
}
