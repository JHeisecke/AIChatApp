//
//  CategoryListView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-29.
//

import SwiftUI

struct CategoryListView: View {

    @Binding var path: [NavigationPathOption]
    var category: CharacterOption = .alien
    var imageName: String = Constants.randomImage
    @State private var avatars: [AvatarModel] = AvatarModel.mocks

    var body: some View {
        List {
            CategoryCellView(
                title: category.plural.capitalized,
                imageName: imageName,
                font: .largeTitle,
                cornerRadius: 0
            )
            .removeListRowFormatting()
            ForEach(avatars, id: \.avatarId) { avatar in
                CustomListCellView(
                    imageName: avatar.profileImageName,
                    title: avatar.name,
                    subtitle: avatar.characterDescription
                )
                .removeListRowFormatting()
                .anyButton(.highlight) {
                    onAvatarPressed(avatar: avatar)
                }
            }
        }
        .ignoresSafeArea()
        .listStyle(.plain)
    }

    // MARK: - Actions

    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarId: avatar.avatarId))
    }
}

#Preview {
    CategoryListView(path: .constant([]))
}
