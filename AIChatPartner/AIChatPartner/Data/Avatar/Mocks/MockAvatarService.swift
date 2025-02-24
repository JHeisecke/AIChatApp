//
//  MockAvatarService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-19.
//

import SwiftUI

struct MockAvatarService: RemoteAvatarService {

    let avatars: [AvatarModel]
    let delay: Double
    let showError: Bool

    init(avatars: [AvatarModel] = AvatarModel.mocks, delay: Double = 0, showError: Bool = false) {
        self.avatars = avatars
        self.delay = delay
        self.showError = showError
    }

    private func tryShowError() throws {
        if showError {
            throw URLError(.unknown)
        }
    }

    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {

    }

    func getFeaturedAvatars() async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return avatars.shuffled()
    }

    func getPopularAvatars() async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return avatars.shuffled()
    }

    func getAvatars(by category: CharacterOption) async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return avatars.shuffled()
    }

    func getAvatars(byAuthor id: String) async throws -> [AvatarModel] {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return avatars.shuffled()
    }

    func getAvatar(id: String) async throws -> AvatarModel {
        guard let avatar = avatars.first(where: { $0.avatarId == id }) else { throw URLError(.noPermissionsToReadFile) }
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return avatar
    }

    func incrementAvatarClickCount(avatarId: String) async throws {
        
    }

    func removeAuthorIdFromAvatar(avatarId: String) async throws {

    }

    func removeAuthorIdFromAllUserAvatars(authorId: String) async throws {
        
    }
}
