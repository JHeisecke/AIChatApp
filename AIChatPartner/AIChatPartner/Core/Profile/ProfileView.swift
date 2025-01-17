//
//  ProfileView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI

struct ProfileView: View {

    @State private var showSettingsView: Bool = false
    @State private var showCreateAvatarView: Bool = false
    @State private var currentUser: UserModel? = UserModel.mock
    @State private var myAvatars: [AvatarModel]?
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            List {
                myInfoSection
                    .removeListRowFormatting()
                myAvatarSection
                    .removeListRowFormatting()
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    settingsButton
                }
            }
        }
        .sheet(isPresented: $showSettingsView) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $showCreateAvatarView) {
            Text("Create Avatar")
        }
        .task {
            isLoading = true
            await loadData()
        }
    }

    private var settingsButton: some View {
        Image(systemName: "gear")
            .font(.headline)
            .foregroundStyle(.accent)
            .anyButton {
                onSettingsButtonPressed()
            }
    }

    private var myAvatarSection: some View {
        Section {
            if let myAvatars, !myAvatars.isEmpty {
                ForEach(myAvatars, id: \.self) { avatar in
                    CustomListCellView(
                        imageName: avatar.profileImageName,
                        title: avatar.name,
                        subtitle: nil
                    )
                    .anyButton(.highlight) {

                    }
                }
                .onDelete { indexSet in
                    onDeleteAvatar(indexSet: indexSet)
                }
            } else {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Click + to create an avatar")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
        } header: {
            HStack(spacing: 0) {
                Text("My avatars")
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundStyle(.accent)
                    .anyButton {
                        onNewAvatarButtonPressed()
                    }
            }
            .padding(16)
        }
    }

    private var myInfoSection: some View {
        Section {
            ZStack {
                Circle()
                    .fill(currentUser?.profileColorCalculated ?? .accent)
            }
            .frame(width: 100, height: 100)
            .frame(maxWidth: .infinity)
        }
    }

    private func loadData() async {
        try? await Task.sleep(for: .seconds(5))
        isLoading = false
        myAvatars = AvatarModel.mocks
    }

    private func onDeleteAvatar(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        myAvatars?.remove(at: index)
    }

    private func onSettingsButtonPressed() {
        showSettingsView = true
    }

    private func onNewAvatarButtonPressed() {
        showCreateAvatarView = true
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
    .environment(AppState())
}
