//
//  UserServices.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-18.
//

protocol UserServices {
    var remote: RemoteUserService { get }
    var local: LocalUserPersistance { get }
}

struct MockUserServices: UserServices {
    let remote: RemoteUserService
    let local: LocalUserPersistance

    init(user: UserModel? = nil) {
        self.remote = MockUserService(user: user)
        self.local = MockUserPersistance(user: user)
    }
}

struct ProductionUserServices: UserServices {
    let remote: RemoteUserService = FirebaseUserService()
    let local: LocalUserPersistance = FileManagerUserPersistance()
}
