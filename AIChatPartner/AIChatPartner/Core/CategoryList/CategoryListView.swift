//
//  CategoryListView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-29.
//

import SwiftUI

struct CategoryListView: View {

    @Environment(AvatarManager.self) private var avatarManager
    @Binding var path: [NavigationPathOption]

    var category: CharacterOption
    var imageName: String

    @State private var isLoading = true
    @State private var showAlert: AnyAppAlert?
    @State private var avatars: [AvatarModel] = []

    var body: some View {
        List {
            CategoryCellView(
                title: category.plural.capitalized,
                imageName: imageName,
                font: .largeTitle,
                cornerRadius: 0
            )
            .removeListRowFormatting()
            if avatars.isEmpty && isLoading {
                ProgressView()
                    .padding(40)
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    .removeListRowFormatting()
            } else {
                ForEach(avatars, id: \.avatarId) { avatar in
                    avatarCell(avatar)
                }
            }
        }
        .showCustomAlert(alert: $showAlert)
        .ignoresSafeArea()
        .listStyle(.plain)
        .task {
            await loadAvatars()
        }
    }

    private func avatarCell(_ avatar: AvatarModel) -> some View {
        CustomListCellView(
            imageName: avatar.profileImageName,
            title: avatar.name,
            subtitle: avatar.characterDescription
        )
        .anyButton(.highlight) {
            onAvatarPressed(avatar: avatar)
        }
        .removeListRowFormatting()
    }

    private func loadAvatars() async {
        do {
            avatars = try await avatarManager.getAvatars(by: category)
        } catch {
            showAlert = AnyAppAlert(error: error)
        }
    }

    // MARK: - Actions

    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarId: avatar.avatarId))
    }
}

#Preview {
    CategoryListView(path: .constant([]), category: .alien, imageName: Constants.randomImage)
        .environment(AvatarManager(service: MockAvatarService()))
}
