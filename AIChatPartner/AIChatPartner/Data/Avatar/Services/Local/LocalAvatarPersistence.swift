//
//  LocalAvatarPersistence.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-22.
//

import Foundation

@MainActor
protocol LocalAvatarPersistence {
    func addRecentAvatar(avatar: AvatarModel) throws
    func getRecentAvatar() throws -> [AvatarModel]
}
