//
//  MockAvatarService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-19.
//

import SwiftUI

struct MockAvatarService: RemoteAvatarService {
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {

    }

    func getFeaturedAvatars() async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(2))
        return AvatarModel.mocks.shuffled()
    }

    func getPopularAvatars() async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(3))
        return AvatarModel.mocks.shuffled()
    }

    func getAvatars(by category: CharacterOption) async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(1))
        return AvatarModel.mocks.shuffled()
    }

    func getAvatars(by author: String) async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(1))
        return AvatarModel.mocks.shuffled()
    }

    func getAvatar(id: String) async throws -> AvatarModel {
        try await Task.sleep(for: .seconds(1))
        return AvatarModel.mock
    }

    func incrementAvatarClickCount(avatarId: String) async throws {
        
    }
}
