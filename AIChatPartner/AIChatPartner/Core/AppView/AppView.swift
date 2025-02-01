//
//  AppView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI

struct AppView: View {

    @Environment(\.authService) private var authService
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
        .environment(appState) // dependency injection mechanism for SwiftUI
        .task {
            await checkUserStatus()
        }
        .onChange(of: appState.showTabBar) { _, showTabBar in
            guard !showTabBar else { return }
            Task {
                await checkUserStatus()
            }
        }
    }

    private func checkUserStatus() async {
        if let user = authService.getAuthenticatedUser() {
            print("User already authenticated: \(user.uid)")
        } else {
            do {
                let result = try await authService.signInAnonymously()
                // log in to app
                print("anonymous signed in succesfull \(result.user.uid)")
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    AppView(appState: AppState(showTabBar: true))
}

#Preview {
    AppView(appState: AppState(showTabBar: false))
}
