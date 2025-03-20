//
//  AuthManager.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-17.
//

import SwiftUI

@MainActor
@Observable
class UserManager {
    private let remote: RemoteUserService
    private let local: LocalUserPersistance

    private(set) var currentUser: UserModel?
    private var currentUserListenerTask: Task<Void, Error>?

    init(service: UserServices) {
        self.remote = service.remote
        self.local = service.local
        self.currentUser = local.getCurrentUser()
        print(NSHomeDirectory())
    }

    private func getCurrentUserId() throws -> String {
        guard let id = currentUser?.userId else { throw UserManagerError.noUserId }
        return id
    }

    private func addCurrentUserListener(userId: String) {
        currentUserListenerTask?.cancel()
        currentUserListenerTask = Task {
            do {
                for try await value in remote.streamUser(userId: userId) {
                    self.currentUser = value
                    self.saveCurrentUserLocally()
                    print("Current user listener success: \(currentUser?.userId ?? "nil")")
                }
            } catch {
                print("Error attaching user listener")
            }
        }
    }

    func markOnboardingCompleteForCurrentUser(profileColorHex: String) async throws {
        let uid = try getCurrentUserId()
        try await remote.markOnboardingAsCompleted(userId: uid, profileColorHex: profileColorHex)
    }

    func logIn(auth: UserAuthInfo, isNewUser: Bool) async throws {
        let creationVersion = isNewUser ? Utilities.appVersion : nil
        let user = UserModel(auth: auth, creationVersion: creationVersion)
        try await remote.saveUser(user: user)
        addCurrentUserListener(userId: user.userId)
    }

    func signOut() {
        currentUserListenerTask?.cancel()
        currentUserListenerTask = nil
        currentUser = nil
    }

    func deleteCurrentUser() async throws {
        let uid = try getCurrentUserId()
        try await remote.deleteUser(userId: uid)
        signOut()
    }

    private func saveCurrentUserLocally() {
        Task {
            do {
                try local.saveCurrentUser(user: currentUser)
                print("Success saved current user locally")
            } catch {
                print("Error saving current user locally: \(error)")
            }
        }
    }
}
