//
//  FileManagerUserPersistance.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-17.
//
import SwiftUI

struct FileManagerUserPersistance: LocalUserPersistance {
    private let userDocumentKey = "current_user"
    
    func getCurrentUser() -> UserModel? {
        try? FileManager.getDocument(key: userDocumentKey)
    }
    
    func saveCurrentUser(user: UserModel?) throws {
        try FileManager.saveDocument(key: userDocumentKey, value: user)
    }
}
