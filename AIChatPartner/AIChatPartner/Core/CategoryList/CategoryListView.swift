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
            if avatars.isEmpty {
                if isLoading {
                    loadingIndicator
                } else {
                    emptyView
                }
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

    private var loadingIndicator: some View {
        ProgressView()
            .padding(40)
            .frame(maxWidth: .infinity)
            .listRowSeparator(.hidden)
            .removeListRowFormatting()
    }

    private var emptyView: some View {
        Text("No avatars for this category")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .removeListRowFormatting()
            .listRowSeparator(.hidden)
            .padding(30)
            .frame(maxWidth: .infinity)
    }

    // MARK: - Cell

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

    // MARK: - Data

    private func loadAvatars() async {
        do {
            avatars = try await avatarManager.getAvatars(by: category)
        } catch {
            showAlert = AnyAppAlert(error: error)
        }
        isLoading = false
    }

    // MARK: - Actions

    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarId: avatar.avatarId))
    }
}

#Preview("Has Data") {
    CategoryListView(path: .constant([]), category: .alien, imageName: Constants.randomImage)
        .environment(AvatarManager(service: MockAvatarService()))
}

#Preview("No Data") {
    CategoryListView(path: .constant([]), category: .alien, imageName: Constants.randomImage)
        .environment(AvatarManager(service: MockAvatarService(avatars: [])))
}

#Preview("Slow Loading") {
    CategoryListView(path: .constant([]), category: .alien, imageName: Constants.randomImage)
        .environment(AvatarManager(service: MockAvatarService(delay: 10)))
}

#Preview("Error View") {
    CategoryListView(path: .constant([]), category: .alien, imageName: Constants.randomImage)
        .environment(AvatarManager(service: MockAvatarService(showError: true)))
}
