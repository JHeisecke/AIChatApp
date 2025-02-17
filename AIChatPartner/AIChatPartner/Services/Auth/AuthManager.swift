//
//  AuthManager.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-17.
//

import SwiftUI

@MainActor
@Observable
class AuthManager {
    private let service: AuthService
    private(set) var auth: UserAuthInfo?
    private var listener: (any NSObjectProtocol)?

    init(service: AuthService) {
        self.service = service
        self.auth = service.getAuthenticatedUser()
    }

    private func addAuthListener() {
        Task {
            for await value in service.addAuthenticatedUserListener(onListenerAttached: { listener in
                self.listener = listener
            }) {
                self.auth = value
                print("Auth listener success: \(value?.uid ?? "nil")")
            }
        }
    }

    func getAuthId() throws -> String {
        guard let uid = auth?.uid else { throw AuthError.notSignedIn }
        return uid
    }

    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        try await service.signInAnonymously()
    }

    func signInApple() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        try await service.signInApple()
    }

    func signOut() throws {
        try service.signOut()
        auth = nil
    }

    func deleteAccount() async throws {
        try await service.deleteAccount()
        auth = nil
    }
}
