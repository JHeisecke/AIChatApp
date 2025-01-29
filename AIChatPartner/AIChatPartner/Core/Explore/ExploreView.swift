//
//  ExploreView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI

struct ExploreView: View {

    // MARK: - Properties

    @State private var featureAvatars: [AvatarModel] = AvatarModel.mocks
    @State private var categories: [CharacterOption] = CharacterOption.allCases
    @State private var popularAvatars: [AvatarModel] = AvatarModel.mocks

    @State private var path: [NavigationPathOption] = []

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Group {
                    featuredSection
                    categoriesSection
                    popularSection
                }
                .removeListRowFormatting()
            }
            .navigationTitle(
                "Explore"
            )
            .navigationDestionationForCoreModule(path: $path)
        }
    }

    // MARK: - Featured Section

    private var featuredSection: some View {
        Section(
            content: {
                ZStack {
                    CarouselView(
                        items: featureAvatars
                    ) { avatar in
                        HeroCellView(
                            title: avatar.name,
                            subtitle: avatar.characterDescription,
                            imageName: avatar.profileImageName
                        )
                        .anyButton {
                            onAvatarPressed(avatar: avatar)
                        }
                    }
                }
            },
            header: {

            }
        )
    }

    // MARK: - Categories Section

    private var categoriesSection: some View {
        Section {
            ZStack {
                ScrollView(.horizontal) {
                    categoriesContent
                }
                .frame(height: 140)
                .scrollIndicators(.hidden)
                .scrollTargetLayout()
                .scrollTargetBehavior(.viewAligned)
            }
        } header: {

        }
    }

    private var categoriesContent: some View {
        HStack(spacing: 12) {
            ForEach(categories, id: \.self) { category in
                let imageName = popularAvatars.first(where: { $0.characterOption == category })?.profileImageName
                if let imageName {
                    CategoryCellView(
                        title: category.plural.capitalized,
                        imageName: imageName
                    )
                    .anyButton {
                        onCategoryPressed(category: category, imageName: imageName)
                    }
                }
            }
        }
    }

    // MARK: - Popular Section

    private var popularSection: some View {
        Section(
            content: {
                ForEach(popularAvatars, id: \.self) { avatar in
                    CustomListCellView(
                        imageName: avatar.profileImageName,
                        title: avatar.name,
                        subtitle: avatar.characterDescription
                    )
                    .anyButton(.highlight) {
                        onAvatarPressed(avatar: avatar)
                    }
                }
            },
            header: {

            }
        )
    }

    // MARK: - Actions

    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarId: avatar.avatarId))
    }

    private func onCategoryPressed(category: CharacterOption, imageName: String) {
        path.append(.category(category: category, imageName: imageName))
    }
}

#Preview {
    NavigationStack {
        ExploreView()
    }
}
