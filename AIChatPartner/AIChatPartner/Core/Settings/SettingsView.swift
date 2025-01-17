//
//  SettingsView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI

struct SettingsView: View {

    @Environment(AppState.self) var appState
    @Environment(\.dismiss) private var dismiss

    @State private var isPremium = true
    @State private var isAnonymousUser = true
    @State private var showCreateAccountScreen = false

    var body: some View {
        NavigationStack {
            List {
                accountSection
                purchasesSection
                applicationSection

            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showCreateAccountScreen) {
                CreateAccountView()
                    .presentationDetents([.medium])
            }
        }
    }

    // MARK: - Application Section

    private var applicationSection: some View {
        Section {
            HStack(spacing: 8) {
                Text("Version")
                Spacer(minLength: 0)
                Text(Utilities.appVersion ?? "")
                    .foregroundStyle(.secondary)
            }
            .rowFormatting()
            .removeListRowFormatting()
            HStack(spacing: 8) {
                Text("Build Number")
                Spacer(minLength: 0)
                Text(Utilities.buildNumber ?? "")
                    .foregroundStyle(.secondary)
            }
            .rowFormatting()
            .removeListRowFormatting()
            Text("Contact us")
                .foregroundStyle(.blue)
                .rowFormatting()
                .anyButton(.highlight) {
                    onContactUsPressed()
                }
                .removeListRowFormatting()
        } header: {
            Text("APPLICATION")
        } footer: {
            Text("Created by Javier Heisecke\nSee the codebase at https://github.com/JHeisecke/AIChatApp.")
                .baselineOffset(5)
        }
    }

    // MARK: - Purchases Section

    private var purchasesSection: some View {
        Section {
            HStack(spacing: 8) {
                Text("Account status: \(isPremium ? "PREMIUM" : "FREE")")
                Spacer(minLength: 0)
                if isPremium {
                    Text("MANAGE")
                        .badgeLabel()
                }
            }
            .rowFormatting()
            .anyButton(.highlight) {
            }
            .disabled(!isPremium)
            .removeListRowFormatting()
        } header: {
            Text("Purhases")
        }
    }

    // MARK: - Account Section

    private var accountSection: some View {
        Section {
            if isAnonymousUser {
                Text("Save & back-up account")
                    .rowFormatting()
                    .anyButton(.highlight) {
                        onCreateAccountPressed()
                    }
                    .removeListRowFormatting()
            } else {
                Text("Sign out")
                    .rowFormatting()
                    .anyButton(.highlight) {
                        onSignOutPressed()
                    }
                    .removeListRowFormatting()
            }
            Text("Delete")
                .foregroundStyle(.red)
                .rowFormatting()
                .anyButton(.highlight) {
                    onSignOutPressed()
                }
                .removeListRowFormatting()
        } header: {
            Text("Account")
        }
    }

    func onCreateAccountPressed() {
        showCreateAccountScreen = true
    }

    func onSignOutPressed() {
        dismiss()
        Task {
            try? await Task.sleep(for: .seconds(1))
        }
        appState.updateViewState(showTabBarView: false)
    }

    func onContactUsPressed() {

    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .environment(AppState())
}

// MARK: - View Extension

fileprivate extension View {
    func rowFormatting() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color(uiColor: .systemBackground))
    }
}
