//
//  MockUserService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-18.
//

import Foundation

struct MockUserService: RemoteUserService {
    
    let currentUser: UserModel?
    
    init(user: UserModel? = nil) {
        self.currentUser = user
    }
    
    func saveUser(user: UserModel) async throws {
        
    }
    
    func markOnboardingAsCompleted(userId: String, profileColorHex: String) async throws {

    }
    
    func streamUser(userId: String) -> AsyncThrowingStream<UserModel, any Error> {
        AsyncThrowingStream { continuation in
            if let currentUser {
                continuation.yield(currentUser)
            }
        }
    }
    
    func deleteUser(userId: String) async throws {
        
    }
    
}
