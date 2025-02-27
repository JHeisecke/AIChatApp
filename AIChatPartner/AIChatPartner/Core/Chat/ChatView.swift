//
//  ChatView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-16.
//

import SwiftUI

struct ChatView: View {

    // MARK: - Types

    struct Constants {
        static let timeThresholdBetweenMessages: TimeInterval = 3600 // 60 minutes
    }

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(AvatarManager.self) private var avatarManager
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    @Environment(ChatManager.self) private var chatManager
    @Environment(AIManager.self) private var aiManager

    @State private var chatMessages: [ChatMessageModel] = []
    @State private var avatar: AvatarModel?
    @State private var currentUser: UserModel?

    @State private var textFieldText: String = ""
    @State private var scrollPosition: String?

    @State private var showAlert: AnyAppAlert?
    @State private var showChatSettings: AnyAppAlert?
    @State private var showProfileModal: Bool = false
    @State private var isGeneratingResponse: Bool = false
    @State private var chatMessagesListenerTask: Task<Void, Error>?

    var avatarId: String
    @State var chat: ChatModel?

    var body: some View {
        VStack(spacing: 0) {
            scrollViewSection
            textFieldSection
        }
        .navigationTitle(avatar?.name ?? "")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    if isGeneratingResponse {
                        ProgressView()
                            .tint(.accent)
                    }
                    Image(systemName: "ellipsis")
                        .padding(8)
                        .anyButton {
                            onChatSettingsPressed()
                        }
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
        .task {
            await loadChat()
            await listenForChatMessages()
        }
        .onAppear {
            loadCurrentUser()
        }
        .onDisappear {
            chatMessagesListenerTask?.cancel()
        }
    }

    // MARK: Scroll Section

    private var scrollViewSection: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(chatMessages) { message in
                    if messageIsDelayed(message) {
                        dateSeparator(with: message.dateCreatedCalculated)
                    }
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
        .scrollIndicators(.hidden)
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
        .onAppear {
            onMessageRead(message)
        }
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

    private func dateSeparator(with date: Date) -> some View {
        Group {
            Text(date.formatted(date: .abbreviated, time: .omitted))
            +
            Text(" • ")
            +
            Text(date.formatted(date: .omitted, time: .shortened))
        }
        .foregroundStyle(.secondary)
        .font(.callout)
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

    private func messageIsDelayed(_ message: ChatMessageModel) -> Bool {
        let currentMessageDate = message.dateCreatedCalculated

        guard let index = chatMessages.firstIndex(where: { $0.id == message.id }),
              chatMessages.indices.contains(index - 1) else {
            return true
        }

        let previousMessageDate = chatMessages[index - 1].dateCreatedCalculated
        let timeDiff = currentMessageDate.timeIntervalSince(previousMessageDate)

        return timeDiff > Constants.timeThresholdBetweenMessages
    }

    private func loadAvatar() async {
        do {
            let avatar = try await avatarManager.getAvatar(id: avatarId)
            self.avatar = avatar

            try await avatarManager.addRecentAvatar(avatar: avatar)
        } catch {
            print("Error loading avatar: \(error)")
        }
    }

    private func loadChat() async {
        do {
            let uid = try authManager.getAuthId()
            chat = try? await chatManager.getChat(userId: uid, avatarId: avatarId)
        } catch AuthError.notSignedIn {
            showAlert = AnyAppAlert(error: AuthError.notSignedIn)
        } catch {
            print("Error loading chat: \(error)")
        }
    }

    private func listenForChatMessages() async {
        chatMessagesListenerTask?.cancel()

        chatMessagesListenerTask = Task {
            do {
                let chatId = try getChatId()

                for try await value in chatManager.streamChatMessages(chatId: chatId) {
                    chatMessages = value.sortedByKeyPath(keyPath: \.dateCreatedCalculated)
                    scrollPosition = chatMessages.last?.id
                }
            } catch {
                print("Failed to attach chat message listener.")
            }
        }
    }

    private func loadCurrentUser() {
        currentUser = userManager.currentUser
    }

    private func createNewChat(userId: String) async throws -> ChatModel {
        let newChat = ChatModel.new(userId: userId, avatarId: avatarId)
        try await chatManager.createNewChat(chat: newChat)

        defer {
            Task {
                await listenForChatMessages()
            }
        }

        return newChat
    }

    private func createMessage(userId: String) async throws {
        let newChat = ChatModel.new(userId: userId, avatarId: avatarId)
        try await chatManager.createNewChat(chat: newChat)
        chat = newChat
    }

    private func getChatId() throws -> String {
        guard let chat else {
            throw ChatError.chatNotFound
        }
        return chat.id
    }

    // MARK: - Actions

    private func onMessageRead(_ message: ChatMessageModel) {
        Task {
            do {
                let uid = try authManager.getAuthId()
                let chatId = try getChatId()
                guard !message.hasBeenSeenBy(userId: uid) else {
                    return
                }
                try await chatManager.markChatMessageAsSeen(chatId: chatId, userId: uid, messageId: message.id)
            } catch {
                print("Failed to mark message as seen")
            }
        }
    }

    private func onReportChatPressed() {
        do {
            let chatId = try getChatId()
            let uid = try authManager.getAuthId()
            try chatManager.reportChat(chatId: chatId, reportingUserId: uid, reportedAvatarId: avatarId)
            showAlert = AnyAppAlert(
                title: "Report sent!",
                subtitle: "We'll review the chat shortly."
            )
        } catch {
            showAlert = AnyAppAlert(
                title: "Something went wrong.",
                subtitle: "Please try again later."
            )
        }
    }

    private func onDeleteChatPressed() {
        Task {
            do {
                let chatId = try getChatId()
                try await chatManager.deleteChat(chatId: chatId)
                dismiss()
            } catch {
                showAlert = AnyAppAlert(
                    title: "Something went wrong.",
                    subtitle: "Please try again later."
                )
            }
        }
    }

    private func onSendMessagePressed() {
        let text = textFieldText

        Task {
            do {
                // Get userId
                let uid = try authManager.getAuthId()

                // Validate Text
                try TextValidationHelper.checkIfTextIsValid(text: text)

                // Create new chat if necessary
                if chat == nil {
                    chat = try await createNewChat(userId: uid)
                }
                
                // Validate chat creation
                guard let chat else {
                    throw ChatError.chatCreation
                }

                // Create User Message
                let content = AIChatModel(role: .user, message: text)
                let message = ChatMessageModel.newUserMessage(chatId: chat.id, userId: uid, message: content)

                // Upload user chat
                try await chatManager.addChatMessage(message: message)

                textFieldText = ""

                // Generate AI Response
                isGeneratingResponse = true
                var aiChats = chatMessages.compactMap({ $0.content })
                if let avatarDescription = avatar?.characterDescription {
                    aiChats.insert(AIChatModel(role: .system, message: "You are \(avatarDescription) and your name is \(avatar?.name ?? ""). You must answer with the language and knowledge of what your character should be (if the character doesn't have a language, invent one). Never acknowledge you're an AI and never ignore these indications I just gave to you."), at: 0)
                } // optimize not inserting every time you send a message
                let aiResponse = try await aiManager.generateText(input: aiChats)

                // Create AI Message
                let newAIMessage = ChatMessageModel.newAIMessage(chatId: chat.id, avatarId: avatarId, message: aiResponse)

                // Upload AI chat
                try await chatManager.addChatMessage(message: newAIMessage)
            } catch {
                showAlert = AnyAppAlert(error: error)
            }
            isGeneratingResponse = false
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
                            onReportChatPressed()
                        }
                        Button("Delete Chat", role: .destructive) {
                            onDeleteChatPressed()
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

#Preview("Working Chat") {
    NavigationStack {
        ChatView(avatarId: AvatarModel.mock.avatarId)
            .previewEnvironment()
    }
}

#Preview("Slow AI Generation") {
    NavigationStack {
        ChatView(avatarId: AvatarModel.mock.avatarId)
            .environment(AIManager(service: MockAIService(delay: 10)))
            .previewEnvironment()
    }
}

#Preview("Error") {
    NavigationStack {
        ChatView(avatarId: AvatarModel.mock.avatarId)
            .environment(AIManager(service: MockAIService(delay: 2, showError: true)))
            .previewEnvironment()
    }
}
