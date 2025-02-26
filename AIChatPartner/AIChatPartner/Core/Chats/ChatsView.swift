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

    @Environment(AuthManager.self) private var authManager
    @Environment(AvatarManager.self) private var avatarManager
    @Environment(ChatManager.self) private var chatManager

    @State private var chatsState: ChatsState = .data(chats: [])
    @State private var recentAvatars: [AvatarModel] = []

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
            .onAppear {
                loadRecentAvatars()
            }
            .task {
                await loadChats()
            }
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
                currentUserId: authManager.auth?.uid,
                chat: chat,
                getAvatar: {
                    return try? await avatarManager.getAvatar(id: chat.avatarId)
                },
                getLastChatMessage: {
                    return try? await chatManager.getLastChatMessage(chatId: chat.id)
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

    // MARK: - Data

    private func loadRecentAvatars() {
        do {
            recentAvatars = try avatarManager.getRecentAvatar()
        } catch {
            print("Error getting recent avatars. \(error)")
        }
    }

    private func loadChats() async {
        do {
            let uid = try authManager.getAuthId()
            let chats = try await chatManager.getAllChats(userId: uid)
            if chats.isEmpty {
                chatsState = .empty
            } else {
                chatsState = .data(chats: chats.sortedByKeyPath(keyPath: \.dateModified, ascending: false))
            }
        } catch {
            chatsState = .empty
            print("Failed to load chats")
        }
    }

    // MARK: - Actions

    private func onChatPressed(chat: ChatModel) {
        path.append(.chat(avatarId: chat.avatarId, chat: chat))
    }

    private func onAvatarPressed(avatar: AvatarModel) {
        path.append(.chat(avatarId: avatar.avatarId, chat: nil))
    }
}

#Preview("Has Data") {
    ChatsView()
        .previewEnvironment()
}

#Preview("Slow Loading") {
    ChatsView()
        .environment(ChatManager(service: MockChatService(delay: 5)))
        .previewEnvironment()
}

#Preview("No Data") {
    ChatsView()
        .environment(AvatarManager(service: MockAvatarService(avatars: []), local: MockLocalAvatarPersistance(avatars: [])))
        .environment(ChatManager(service: MockChatService(chats: [])))
        .previewEnvironment()
}
