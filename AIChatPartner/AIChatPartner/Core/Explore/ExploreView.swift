//
//  ExploreView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI

struct ExploreView: View {

    @State private var featureAvatars: [AvatarModel] = AvatarModel.mocks
    @State private var categories: [CharacterOption] = CharacterOption.allCases
    @State private var popularAvatars: [AvatarModel] = AvatarModel.mocks

    var body: some View {
        NavigationStack {
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
                    }
                    .anyButton(.press) {

                    }
                }
            },
            header: {

            }
        )
    }

    // MARK: - Categories Section

    private var categoriesSection: some View {
        Section(
            content: {
                ZStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                CategoryCellView(
                                    title: category.rawValue.capitalized,
                                    imageName: Constants.randomImage
                                )
                            }
                        }
                    }
                    .frame(height: 140)
                    .scrollIndicators(.hidden)
                    .scrollTargetLayout()
                    .scrollTargetBehavior(.viewAligned)

                }
            },
            header: {

            }
        )
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

                    }
                }
            },
            header: {

            }
        )
    }
}

#Preview {
    NavigationStack {
        ExploreView()
    }
}
