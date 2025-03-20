//
//  DevSettingsView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-28.
//

import SwiftUI

extension Dictionary where Key == String, Value == Any {
    var asAlphabeticalArray: [(key: String, value: Any)] {
        self.map({
            (key: $0.key, value: $0.value)
        }).sortedByKeyPath(keyPath: \.key)
    }
}

struct DevSettingsView: View {

    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                authSection
                userSection
                deviceSection
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .fontWeight(.bold)
                        .anyButton {
                            onBackButtonPressed()
                        }
                }
            }
        }
    }

    // MARK: - Auth Info

    private var authSection: some View {
        Section {
            let userAuthInfo = authManager.auth?.eventParameters.asAlphabeticalArray

            if let userAuthInfo {
                ForEach(userAuthInfo, id: \.key) { item in
                    itemRow(item)
                }
            }
        } header: {
            Text("Auth Info")
        }
    }

    // MARK: - User Info

    private var userSection: some View {
        Section {
            let userInfo = userManager.currentUser?.eventParameters.asAlphabeticalArray

            if let userInfo {
                ForEach(userInfo, id: \.key) { item in
                    itemRow(item)
                }
            }
        } header: {
            Text("User Info")
        }
    }

    // MARK: - Device Info

    private var deviceSection: some View {
        Section {
            let deviceInfo = Utilities.eventParameters.asAlphabeticalArray

            ForEach(deviceInfo, id: \.key) { item in
                itemRow(item)
            }
        } header: {
            Text("Device Info")
        }
    }

    // MARK: - Item Row

    private func itemRow(_ item: (key: String, value: Any)) -> some View {
        HStack {
            Text(item.key)
            Spacer(minLength: 4)
            Text(String.toString(item.value) ?? "Unknown")
        }
        .font(.caption)
        .lineLimit(1)
        .minimumScaleFactor(0.3)
    }

    // MARK: - Actions

    private func onBackButtonPressed() {
        dismiss()
    }
}

// MARK: - Previews

#Preview {
    DevSettingsView()
        .previewEnvironment()
}
