//
//  MockUserPersistance.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-17.
//

struct MockUserPersistance: LocalUserPersistance {
    
    let currentUser: UserModel?
    
    init(user: UserModel? = nil) {
        self.currentUser = user
    }
    
    func getCurrentUser() -> UserModel? {
        currentUser
    }
    
    func saveCurrentUser(user: UserModel?) throws {
        
    }
}
