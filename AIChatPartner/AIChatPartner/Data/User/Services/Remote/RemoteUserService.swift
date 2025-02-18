//
//  RemoteUserService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-18.
//

import Foundation

protocol RemoteUserService: Sendable {
    func saveUser(user: UserModel) async throws
    func markOnboardingAsCompleted(userId: String, profileColorHex: String) async throws
    func streamUser(userId: String) -> AsyncThrowingStream<UserModel, Error>
    func deleteUser(userId: String) async throws
}
