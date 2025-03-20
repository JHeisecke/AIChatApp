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
    @Environment(LogManager.self) private var logManager

    @State private var categories: [CharacterOption] = CharacterOption.allCases
    @State private var featuredAvatars: [AvatarModel] = []
    @State private var popularAvatars: [AvatarModel] = []
    @State private var isLoadingPopular = true
    @State private var isLoadingFeatured = true

    @State private var path: [NavigationPathOption] = []
    @State private var showDevSettings: Bool = false

    private var showDevSettingsButton: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Group {
                    if featuredAvatars.isEmpty && popularAvatars.isEmpty {
                        ZStack {
                            if isLoadingPopular && isLoadingFeatured {
                                loadingIndicator
                            } else {
                                errorView
                            }
                        }
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
            .toolbar {
                if showDevSettingsButton {
                    ToolbarItem(placement: .topBarLeading) {
                        devSettingsButton
                    }
                }
            }
            .sheet(isPresented: $showDevSettings, content: {
                DevSettingsView()
            })
            .navigationDestionationForCoreModule(path: $path)
            .task {
                await loadFeaturedAvatars()
            }
            .task {
                await loadPopularAvatars()
            }
        }
    }

    private var loadingIndicator: some View {
        ProgressView()
            .padding(40)
            .frame(maxWidth: .infinity)
    }

    // MARK: - Dev Settings

    private var devSettingsButton: some View {
        Text("DEV")
            .badgeLabel()
            .anyButton {
                onDevSettingsPressed()
            }
    }

    private func onDevSettingsPressed() {
        showDevSettings = true
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
                let imageName = popularAvatars.last(where: { $0.characterOption == category })?.profileImageName
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

    // MARK: - Error View

    private var errorView: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Error")
                .font(.headline)
            Text("Please check your internet connection and try again")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("Try again")
                .padding()
                .tappableBackground()
                .anyButton {
                    onTryAgainPressed()
                }
                .tint(.blue)
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .padding(40)
    }

    // MARK: - Data

    private func loadFeaturedAvatars() async {
        guard featuredAvatars.isEmpty else { return }
        isLoadingFeatured = true
        defer {
            isLoadingFeatured = false
        }
        do {
            featuredAvatars = try await avatarManager.getFeaturedAvatars()
        } catch {
            print("Error loading featured avatars: \(error)")
        }
    }

    private func loadPopularAvatars() async {
        guard popularAvatars.isEmpty else { return }
        isLoadingPopular = true
        defer {
            isLoadingPopular = false
        }
        do {
            popularAvatars = try await avatarManager.getPopularAvatars()
        } catch {
            print("Error loading popular avatars: \(error)")
        }
    }

    // MARK: - Actions

    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarId: avatar.avatarId, chat: nil))
    }

    private func onCategoryPressed(category: CharacterOption, imageName: String) {
        logManager.trackScreenEvent(event: AnyLogabbleEvent(eventName: "category_\(category.plural)"))
        path.append(.category(category: category, imageName: imageName))
    }

    private func onTryAgainPressed() {
        Task {
            await loadFeaturedAvatars()
        }
        Task {
            await loadPopularAvatars()
        }
    }
}

// MARK: - Previews

#Preview("Has Data") {
    NavigationStack {
        ExploreView()
            .previewEnvironment()
    }
}

#Preview("No Data") {
    NavigationStack {
        ExploreView()
            .environment(AvatarManager(service: MockAvatarService(avatars: [], delay: 1.0)))
            .previewEnvironment()
    }
}

#Preview("Slow Loading") {
    NavigationStack {
        ExploreView()
            .environment(AvatarManager(service: MockAvatarService(delay: 10.0)))
            .previewEnvironment()
    }
}
