//
//  ChatsView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI

struct ChatsView: View {

    // MARK: - Types

    enum ChatsState {
        case empty
        case data(chats: [ChatModel])
    }

    // MARK: - Properties

    @State private var chatsState: ChatsState = .data(chats: ChatModel.mocks)
    @State private var recentAvatars: [AvatarModel] = AvatarModel.mocks
    @State private var path: [NavigationPathOption] = []

    var body: some View {
        NavigationStack(path: $path) {
            List {
                if !recentAvatars.isEmpty {
                    recentAvatarsSection
                        .removeListRowFormatting()
                }

                switch chatsState {
                case .empty:
                    ContentUnavailableView("Your chats will appear here", systemImage: "bubble.left.and.bubble.right.fill")
                        .removeListRowFormatting()
                case .data(let chats):
                    chatsSection(chats: chats)
                }
            }
            .navigationTitle("Chats")
            .navigationDestionationForCoreModule(path: $path)
        }
    }

    // MARK: - Chats Section

    private var chatsEmptyState: some View {
        Text("Your chats will appear here")
            .foregroundStyle(.secondary)
            .font(.title3)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .padding(40)
            .removeListRowFormatting()
    }

    private func chatsSection(chats: [ChatModel]) -> some View {
        ForEach(chats) { chat in
            ChatRowCellViewBuilder(
                currentUserId: nil, // Add cuid
                chat: chat,
                getAvatar: {
                    try? await Task.sleep(for: .seconds(1))
                    return AvatarModel.mocks.randomElement()!
                },
                getLastChatMessage: {
                    try? await Task.sleep(for: .seconds(1))
                    return ChatMessageModel.mocks.randomElement()!
                }
            )
            .anyButton(.highlight, action: {
                onChatPressed(chat: chat)
            })
            .removeListRowFormatting()
        }
    }

    // MARK: - Recent Avatars Section

    private var recentAvatarsSection: some View {
        Section {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(recentAvatars, id: \.self) { avatar in
                        if let imageName = avatar.profileImageName {
                            VStack(spacing: 8) {
                                ImageLoaderView(urlString: imageName)
                                    .aspectRatio(1, contentMode: .fit)
                                    .clipShape(Circle())
                                Text(avatar.name ?? "")
                                    .font(.caption)
                                    .tint(.secondary)
                            }
                            .anyButton {
                                onAvatarPressed(avatar: avatar)
                            }
                        }
                    }
                }
                .padding(.top, 12)
            }
            .frame(height: 120)
            .scrollIndicators(.hidden)
        } header: {
            Text("Recents")
        }
    }

    // MARK: - Actions

    private func onChatPressed(chat: ChatModel) {
        path.append(.chat(avatarId: chat.avatarId))
    }

    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarId: avatar.avatarId))
    }
}

#Preview {
    ChatsView()
}
