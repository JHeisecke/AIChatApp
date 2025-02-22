//
//  ProfileView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI

struct ProfileView: View {

    // MARK: - Properties
    @Environment(UserManager.self) private var userManager
    @Environment(AuthManager.self) private var authManager
    @Environment(AvatarManager.self) private var avatarManager

    @State private var showSettingsView: Bool = false
    @State private var showCreateAvatarView: Bool = false
    @State private var currentUser: UserModel?
    @State private var myAvatars: [AvatarModel]?
    @State private var isLoading = false
    @State private var path: [NavigationPathOption] = []

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $path) {
            List {
                myInfoSection
                    .removeListRowFormatting()
                myAvatarsSection
                    .removeListRowFormatting()
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    settingsButton
                }
            }
            .navigationDestionationForCoreModule(path: $path)
        }
        .sheet(isPresented: $showSettingsView) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $showCreateAvatarView) {
            CreateAvatarView()
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

    // MARK: - My Avatars Section

    private var myAvatarsSection: some View {
        Section {
            if let myAvatars, !myAvatars.isEmpty {
                ForEach(myAvatars, id: \.self) { avatar in
                    CustomListCellView(
                        imageName: avatar.profileImageName,
                        title: avatar.name,
                        subtitle: nil
                    )
                    .anyButton(.highlight) {
                        onAvatarPressed(avatar: avatar)
                    }
                }
                .onDelete { indexSet in
                    onDeleteAvatar(indexSet: indexSet)
                }
            } else {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
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

    // MARK: - My Info Section

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

    // MARK: - Data

    private func loadData() async {
        currentUser = userManager.currentUser

        do {
            let uid = try authManager.getAuthId()
            myAvatars = try await avatarManager.getAvatars(byAuthor: uid)
        } catch {
            print("Error getting avatars of profile. \(error)")
        }
        isLoading = false
    }

    // MARK: - Actions

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

    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarId: avatar.avatarId))
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
    .environment(AppState())
    .environment(AuthManager(service: MockAuthService(user: nil)))
    .environment(UserManager(service: MockUserServices(user: .mock)))
    .environment(AvatarManager(service: MockAvatarService()))
}
