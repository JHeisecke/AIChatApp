//
//  RemoteAvatarService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-19.
//

import SwiftUI

protocol RemoteAvatarService: Sendable {
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws
    func getFeaturedAvatars() async throws -> [AvatarModel]
    func getPopularAvatars() async throws -> [AvatarModel]
    func getAvatars(by category: CharacterOption) async throws -> [AvatarModel]
    func getAvatars(by author: String) async throws -> [AvatarModel]
    func getAvatar(id: String) async throws -> AvatarModel
    func incrementAvatarClickCount(avatarId: String) async throws
}
