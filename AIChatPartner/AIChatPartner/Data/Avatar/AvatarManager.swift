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
}
