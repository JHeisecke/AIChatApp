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

    var body: some View {
        NavigationStack {
            List {
                featuredSection
                categoriesSection
            }
            .navigationTitle(
                "Explore"
            )
        }
    }

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
                }
                .removeListRowFormatting()
            },
            header: {

            }
        )
    }

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
                .removeListRowFormatting()
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
