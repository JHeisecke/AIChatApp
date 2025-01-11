//
//  OnboardingColorView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-11.
//

import SwiftUI

struct OnboardingColorView: View {

    @State private var selectedColor: Color?
    let profileColors: [Color] = [.red, .green, .orange, .blue, .mint, .purple, .cyan, .teal, .indigo]

    var body: some View {
        ScrollView {
            gridView
                .padding(.horizontal, 24)
        }
        .animation(.smooth, value: selectedColor)
        .safeAreaInset(edge: .bottom) {
            button
                .padding(24)
                .background(Color(uiColor: .systemBackground))
        }
        .animation(.bouncy, value: selectedColor)
    }

    private var gridView: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3),
            alignment: .center,
            spacing: 16,
            pinnedViews: [.sectionHeaders],
            content: {
                Section(content: {
                    ForEach(profileColors, id: \.self) { color in
                        Circle()
                            .fill(.accent)
                            .overlay {
                                color
                                    .clipShape(Circle())
                                    .padding(selectedColor == color ? 10 : 0)
                            }
                            .onTapGesture {
                                selectedColor = color
                            }
                    }
                }, header: {
                    Text("Select a profile color")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                })
            }
        )
    }

    private var button: some View {
        ZStack {
            if selectedColor != nil {
                NavigationLink {
                    OnboardingCompletedView()
                } label: {
                    Text("Continue")
                        .callToActionButton()
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingColorView()
    }
}
