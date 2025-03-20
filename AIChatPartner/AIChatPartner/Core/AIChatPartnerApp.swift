//
//  AIChatPartnerApp.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI
import Mixpanel
import FirebaseCore

// MARK: - AIChatPartnerApp

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
                .environment(delegate.dependencies.chatManager)
                .environment(delegate.dependencies.logManager)
        }
    }
}

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    var dependencies: Dependencies!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let config: BuildConfiguration

        #if MOCK
        config = .mock(signedIn: true)
        #elseif DEV
        config = .dev
        #else
        config = .prod
        #endif

        config.configure()
        dependencies = Dependencies(config: config)
        return true
    }
}

enum BuildConfiguration {
    case mock(signedIn: Bool), dev, prod

    func configure() {
        switch self {
        case .mock:
            return
        case .dev:
            let plist = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist")!
            let options = FirebaseOptions(contentsOfFile: plist)!
            FirebaseApp.configure(options: options)
        case .prod:
            let plist = Bundle.main.path(forResource: "GoogleService-Info-Prod", ofType: "plist")!
            let options = FirebaseOptions(contentsOfFile: plist)!
            FirebaseApp.configure(options: options)
        }
    }
}

// MARK: - Dependencies

@MainActor
struct Dependencies {
    let authManager: AuthManager!
    let userManager: UserManager!
    let aiManager: AIManager!
    let avatarManager: AvatarManager!
    let chatManager: ChatManager!
    let logManager: LogManager!

    init(config: BuildConfiguration) {

        switch config {
        case .mock(let isSignedIn):
            self.authManager = AuthManager(service: MockAuthService(user: isSignedIn ? .mock() : nil))
            self.userManager = UserManager(service: MockUserServices(user: isSignedIn ? UserModel.mock : nil))
            self.aiManager = AIManager(service: MockAIService())
            self.avatarManager = AvatarManager(service: MockAvatarService(), local: MockLocalAvatarPersistance())
            self.chatManager = ChatManager(service: MockChatService())
            self.logManager = LogManager(services: [
                ConsoleService(printParameters: false)
            ])
        case .dev:
            self.authManager = AuthManager(service: FirebaseAuthService())
            self.userManager = UserManager(service: ProductionUserServices())
            self.aiManager = AIManager(service: OpenAIService())
            self.avatarManager = AvatarManager(service: FirebaseAvatarService(), local: SwiftDataLocalAvatarPersistence())
            self.chatManager = ChatManager(service: FirebaseChatService())
            self.logManager = LogManager(services: [
                ConsoleService(), FirebaseAnalyticsService(), MixpanelService(token: Keys.mixpanelKey)
            ])
        case .prod:
            self.authManager = AuthManager(service: FirebaseAuthService())
            self.userManager = UserManager(service: ProductionUserServices())
            self.aiManager = AIManager(service: OpenAIService())
            self.avatarManager = AvatarManager(service: FirebaseAvatarService(), local: SwiftDataLocalAvatarPersistence())
            self.chatManager = ChatManager(service: FirebaseChatService())
            self.logManager = LogManager(services: [FirebaseAnalyticsService(), MixpanelService(token: Keys.mixpanelKey)])
        }
    }
}

// MARK: - View Extension

extension View {
    func previewEnvironment(isSignedIn: Bool = true) -> some View {
        self
            .environment(AppState())
            .environment(AuthManager(service: MockAuthService(user: isSignedIn ? .mock() : nil)))
            .environment(UserManager(service: MockUserServices(user: isSignedIn ? UserModel.mock : nil)))
            .environment(AvatarManager(service: MockAvatarService()))
            .environment(AIManager(service: MockAIService()))
            .environment(ChatManager(service: MockChatService()))
            .environment(LogManager(services: []))
    }
}
