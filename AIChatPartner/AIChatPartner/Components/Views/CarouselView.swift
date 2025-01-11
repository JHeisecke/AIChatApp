//
//  CarouselView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-11.
//

import SwiftUI

struct CarouselView<Model: Hashable, Content: View>: View {

    private(set) var items: [Model]
    @State private var selection: Model?
    @ViewBuilder var content: (Model) -> Content

    var body: some View {
        VStack(spacing: 12) {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(items, id: \.self) { item in
                        content(item)
                        .scrollTransition(.interactive.threshold(.visible(0.95)), transition: { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.9)
                        })
                        .containerRelativeFrame(.horizontal, alignment: .center)
                        .id(item)
                    }
                }
            }
            .frame(height: 200)
            .scrollIndicators(.hidden)
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $selection)
            .onChange(of: items.count) { _, _ in
                updateSelectionIfNeeded()
            }
            .onAppear {
                updateSelectionIfNeeded()
            }

            HStack(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    Circle()
                        .fill(item == selection ? .accent : .secondary.opacity(0.5))
                        .frame(width: 8, height: 8)

                }
            }
            .animation(.linear, value: selection)
        }
    }

    private func updateSelectionIfNeeded() {
        if selection == nil || selection == items.last {
            selection = items.first
        }
    }
}

#Preview {
    CarouselView(items: AvatarModel.mocks, content: { model in
        HeroCellView(
            title: model.name,
            subtitle: model.characterDescription,
            imageName: model.profileImageName
        )
    })
        .padding()
}
