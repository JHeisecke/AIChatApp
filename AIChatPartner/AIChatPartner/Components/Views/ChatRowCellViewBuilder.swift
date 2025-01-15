//
//  ChatRowCellViewBuilder.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-15.
//

import SwiftUI

struct ChatRowCellViewBuilder: View {

    var currentUserId: String?
    var chat: ChatModel
    var getAvatar: () async -> AvatarModel?
    var getLastMessage: () async -> ChatMessageModel?

    @State private var avatar: AvatarModel?
    @State private var lastChatMessage: ChatMessageModel?

    @State private var didLoadAvatar = false
    @State private var didLoadLastMessage = false

    private var isLoading: Bool {
        if didLoadAvatar && didLoadLastMessage {
            return false
        }
        return true
    }

    private var hasNewChat: Bool {
        guard let lastChatMessage, let currentUserId else { return false }
        return lastChatMessage.hasBeenSeenBy(userId: currentUserId)
    }

    private var subheadline: String? {
        if isLoading {
            return "xxxxx xxxxx xxxxx xxxxx"
        }
        if avatar == nil && lastChatMessage == nil {
            return "Error"
        }
        return lastChatMessage?.content
    }

    var body: some View {
        ChatRowCellView(
            imageName: avatar?.profileImageName,
            headline: isLoading ? "xxxx xxxx xxxx" : avatar?.name,
            subheadline: subheadline,
            hasNewChat: isLoading ? false: hasNewChat
        )
        .redacted(reason: isLoading ? .placeholder : [])
        .task {
            avatar = await getAvatar()
            withAnimation {
                didLoadAvatar = true
            }
        }
        .task {
            lastChatMessage = await getLastMessage()
            withAnimation {
                didLoadLastMessage = true
            }
        }
    }
}

#Preview {
    VStack {
        ChatRowCellViewBuilder(
            currentUserId: "",
            chat: ChatModel.mock,
            getAvatar: {
                try? await Task.sleep(for: .seconds(5))
                return .mock
            },
            getLastMessage: {
                try? await Task.sleep(for: .seconds(5))
                return .mock
            }
        )

        ChatRowCellViewBuilder(
            currentUserId: "",
            chat: ChatModel.mock,
            getAvatar: {
                .mock
            },
            getLastMessage: {
                .mock
            }
        )

        ChatRowCellViewBuilder(
            currentUserId: "",
            chat: ChatModel.mock,
            getAvatar: {
                nil
            },
            getLastMessage: {
                nil
            }
        )
    }
}
