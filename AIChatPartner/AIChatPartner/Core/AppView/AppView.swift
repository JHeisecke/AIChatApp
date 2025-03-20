//
//  AppView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI

struct AppView: View {

    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    @Environment(LogManager.self) private var logManager
    @State var appState: AppState = AppState()

    var body: some View {
        AppViewBuilder(
            showTabBar: appState.showTabBar,
            tabbarView: {
                TabBarView()
            },
            onboardingView: {
                WelcomeView()
            }
        )
        .environment(appState)
        .task {
            await checkUserStatus()
        }
        .onChange(of: appState.showTabBar) { _, showTabBar in
            guard !showTabBar else { return }
            Task {
                await checkUserStatus()
            }
        }
        .colorScheme(.light)
    }

    private func checkUserStatus() async {
        logManager.trackEvent(event: AnyLogabbleEvent(eventName: "Hello"))
        if let user = authManager.auth {
            do {
                try await userManager.logIn(auth: user, isNewUser: false)
                logManager.identifyUser(userId: user.uid, email: userManager.currentUser?.email)
            } catch {
                try? await Task.sleep(for: .seconds(5))
                await checkUserStatus()
            }
        } else {
            do {
                let result = try await authManager.signInAnonymously()

                try await userManager.logIn(auth: result.user, isNewUser: result.isNewUser)
                logManager.identifyUser(userId: result.user.uid, email: userManager.currentUser?.email)
            } catch {
                print("Failed to sign in anonymously and log in: \(error)")
                try? await Task.sleep(for: .seconds(5))
                await checkUserStatus()
            }
        }
    }
}

#Preview {
    AppView(appState: AppState(showTabBar: true))
        .previewEnvironment()
}

#Preview {
    AppView(appState: AppState(showTabBar: false))
        .environment(AuthManager(service: MockAuthService(user: nil)))
        .environment(UserManager(service: MockUserServices(user: nil)))
        .environment(LogManager(services: []))
}
