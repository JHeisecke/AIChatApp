//
//  AIChatPartnerApp.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI
import FirebaseCore

@main
struct AIChatPartnerApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(delegate.dependencies.aiManager)
                .environment(delegate.dependencies.avatarManager)
                .environment(delegate.dependencies.userManager)
                .environment(delegate.dependencies.authManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var dependencies: Dependencies!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        dependencies = Dependencies()
        return true
    }
}

@MainActor
struct Dependencies {
    let authManager: AuthManager!
    let userManager: UserManager!
    let aiManager: AIManager!
    let avatarManager: AvatarManager!

    init() {
        self.authManager = AuthManager(service: FirebaseAuthService())
        self.userManager = UserManager(service: ProductionUserServices())
        self.aiManager = AIManager(service: OpenAIService())
        self.avatarManager = AvatarManager(service: FirebaseAvatarService(), local: SwiftDataLocalAvatarPersistence())
    }
}

extension View {
    func previewEnvironment(isSignedIn: Bool = true) -> some View {
        self
            .environment(AppState())
            .environment(AuthManager(service: MockAuthService(user: isSignedIn ? .mock() : nil)))
            .environment(UserManager(service: MockUserServices(user: isSignedIn ? UserModel.mock : nil)))
            .environment(AvatarManager(service: MockAvatarService()))
            .environment(AIManager(service: MockAIService()))
    }
}
