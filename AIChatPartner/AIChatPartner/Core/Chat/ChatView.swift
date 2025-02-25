//
//  ChatView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-16.
//

import SwiftUI

struct ChatView: View {

    // MARK: - Properties
    private let chatId = UUID().uuidString

    @Environment(AvatarManager.self) private var avatarManager
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    @Environment(ChatManager.self) private var chatManager
    @Environment(AIManager.self) private var aiManager

    @State private var chatMessages: [ChatMessageModel] = []
    @State private var avatar: AvatarModel?
    @State private var currentUser: UserModel?
    @State private var chat: ChatModel?

    @State private var textFieldText: String = ""
    @State private var scrollPosition: String?

    @State private var showAlert: AnyAppAlert?
    @State private var showChatSettings: AnyAppAlert?
    @State private var showProfileModal: Bool = false

    var avatarId: String

    var body: some View {
        VStack(spacing: 0) {
            scrollViewSection
            textFieldSection
        }
        .navigationTitle(avatar?.name ?? "")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "ellipsis")
                    .padding(8)
                    .anyButton {
                        onChatSettingsPressed()
                    }
            }
        }
        .showCustomAlert(type: .confirmationDialog, alert: $showChatSettings)
        .showCustomAlert(alert: $showAlert)
        .showModal(showModal: $showProfileModal) {
            if let avatar {
                profileModal(avatar: avatar)
            }
        }
        .task {
            await loadAvatar()
        }
        .onAppear {
            loadCurrentUser()
        }
    }

    // MARK: Scroll Section

    private var scrollViewSection: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(chatMessages) { message in
                    bubbleBuilder(message, isCurrentUser: message.authorId == currentUser?.userId)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .rotationEffect(.degrees(180))
        }
        .rotationEffect(.degrees(180))
        .scrollPosition(id: $scrollPosition, anchor: .center)
        .animation(.default, value: chatMessages.count)
        .animation(.default, value: scrollPosition)
    }

    private func bubbleBuilder(_ message: ChatMessageModel, isCurrentUser: Bool) -> some View {
        ChatBubbleViewBuilder(
            message: message,
            isCurrentUser: isCurrentUser,
            bubbleColor: currentUser?.profileColorCalculated ?? Color.accentColor,
            imageName: isCurrentUser ? nil : avatar?.profileImageName,
            onImagePressed: onAvatarImagePressed
        )
        .id(message.id)
    }

    // MARK: TextField

    private var textFieldSection: some View {
        TextField("Say something...", text: $textFieldText)
            .keyboardType(.alphabet)
            .autocorrectionDisabled()
            .padding(12)
            .padding(.trailing, 60)
            .overlay(
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .padding(.trailing, 4)
                    .foregroundStyle(.accent)
                    .anyButton(.plain, action: {
                        onSendMessagePressed()
                    })
                , alignment: .trailing
            )
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color(uiColor: .systemBackground))

                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                }
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(uiColor: .secondarySystemBackground))
    }

    // MARK: Modal

    private func profileModal(avatar: AvatarModel) -> some View {
        ProfileModalView(
            imageName: avatar.profileImageName,
            title: avatar.name,
            subtitle: avatar.characterOption?.rawValue.capitalized,
            headline: avatar.characterDescription,
            onXMarkPressed: {
                showProfileModal = false
            }
        )
        .padding(40)
        .transition(.slide)
    }

    // MARK: - Data

    private func loadAvatar() async {
        do {
            let avatar = try await avatarManager.getAvatar(id: avatarId)
            self.avatar = avatar

            try await avatarManager.addRecentAvatar(avatar: avatar)
        } catch {
            print("Error loading avatar: \(error)")
        }
    }

    private func loadCurrentUser() {
        currentUser = userManager.currentUser
    }

    // MARK: - Actions

    private func onSendMessagePressed() {
        let text = textFieldText

        Task {
            do {
                let uid = try authManager.getAuthId()
                try TextValidationHelper.checkIfTextIsValid(text: text)

                if chat == nil {
                    let newChat = ChatModel.new(userId: uid, avatarId: avatarId)
                    try await chatManager.createNewChat(chat: newChat)
                    chat = newChat
                }

                let content = AIChatModel(role: .user, message: text)

                let message = ChatMessageModel.newUserMessage(chatId: chatId, userId: uid, message: content)
                chatMessages.append(message)

                scrollPosition = message.id

                textFieldText = ""

                let aiChats = chatMessages.compactMap({ $0.content })
                let aiResponse = try await aiManager.generateText(input: aiChats)

                let newAIMessage = ChatMessageModel.newAIMessage(chatId: chatId, avatarId: avatarId, message: aiResponse)
                chatMessages.append(newAIMessage)
            } catch {
                showAlert = AnyAppAlert(error: error)
            }
        }
    }

    private func onChatSettingsPressed() {
        showChatSettings = AnyAppAlert(
            title: "",
            subtitle: "What would you like to do?",
            buttons: {
                AnyView(
                    Group {
                        Button("Report User / Chat", role: .destructive) {

                        }
                        Button("Delete Chat", role: .destructive) {

                        }
                    }
                )
            }
        )
    }

    private func onAvatarImagePressed() {
        showProfileModal = true
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ChatView(avatarId: "")
            .previewEnvironment()
    }
}
