//
//  AvatarService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-19.
//

import SwiftUI

protocol AvatarService: Sendable {
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws
}
