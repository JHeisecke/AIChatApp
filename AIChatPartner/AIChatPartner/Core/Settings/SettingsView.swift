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

    var body: some View {
        NavigationStack {
            List {
                Button {
                    onSignOutPressed()
                } label: {
                    Text("sign out")
                }
            }
            .navigationTitle("Settings")
        }
    }

    func onSignOutPressed() {
        dismiss()
        Task {
            try? await Task.sleep(for: .seconds(1))
        }
        appState.updateViewState(showTabBarView: false)
    }
}

#Preview {
    SettingsView()
}
