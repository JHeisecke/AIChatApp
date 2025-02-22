//
//  ExploreView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI

struct ExploreView: View {

    // MARK: - Properties

    @Environment(AvatarManager.self) private var avatarManager

    @State private var featuredAvatars: [AvatarModel] = []
    @State private var categories: [CharacterOption] = CharacterOption.allCases
    @State private var popularAvatars: [AvatarModel] = []

    @State private var path: [NavigationPathOption] = []

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Group {
                    if featuredAvatars.isEmpty && popularAvatars.isEmpty {
                        ProgressView()
                            .padding(40)
                            .frame(maxWidth: .infinity)
                    }
                    if !featuredAvatars.isEmpty {
                        featuredSection
                    }
                    if !popularAvatars.isEmpty {
                        categoriesSection
                        popularSection
                    }

                }
                .removeListRowFormatting()
            }
            .navigationTitle(
                "Explore"
            )
            .navigationDestionationForCoreModule(path: $path)
            .task {
                await loadFeaturedAvatars()
            }
            .task {
                await loadPopularAvatars()
            }
        }
    }

    // MARK: - Featured Section

    private var featuredSection: some View {
        Section(
            content: {
                ZStack {
                    CarouselView(
                        items: featuredAvatars
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
                Text("FEATURED")
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
            Text("CATEGORIES")
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
                Text("POPULAR")
            }
        )
    }

    // MARK: - Data

    private func loadFeaturedAvatars() async {
        guard featuredAvatars.isEmpty else { return }
        do {
            featuredAvatars = try await avatarManager.getFeaturedAvatars()
        } catch {
            print("Erro loading featured avatars: \(error)")
        }
    }

    private func loadPopularAvatars() async {
        guard popularAvatars.isEmpty else { return }
        do {
            popularAvatars = try await avatarManager.getPopularAvatars()
        } catch {
            print("Erro loading popular avatars: \(error)")
        }
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
            .environment(AvatarManager(service: MockAvatarService()))
    }
}
