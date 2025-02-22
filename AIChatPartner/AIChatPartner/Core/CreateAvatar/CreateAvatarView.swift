//
//  CreateAvatarView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-16.
//

import SwiftUI

struct CreateAvatarView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(AIManager.self) private var aiManager
    @Environment(AuthManager.self) private var authManager
    @Environment(AvatarManager.self) private var avatarManager

    @State private var avatarName: String = ""
    @State private var characterOption: CharacterOption = .default
    @State private var characterAction: CharacterAction = .default
    @State private var characterLocation: CharacterLocation = .default

    @State private var showAlert: AnyAppAlert?
    @State private var isGenerating: Bool = false
    @State private var generatedImage: UIImage?

    @State private var isSaving: Bool = false

    var body: some View {
        NavigationStack {
            List {
                nameSection
                attributesSection
                imageSection
                saveSection
            }
            .navigationTitle("Create Avatar")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButton
                }
            }
            .showCustomAlert(alert: $showAlert)
        }
    }

    private var backButton: some View {
        Image(systemName: "xmark")
            .font(.title2)
            .fontWeight(.semibold)
            .anyButton(.plain) {
                onBackButtonPressed()
            }
    }

    private var nameSection: some View {
        Section {
            TextField("Player 1", text: $avatarName)
        } header: {
            Text("Name your avatar*")
        }
    }

    private var attributesSection: some View {
        Section {
            Picker(selection: $characterOption) {
                ForEach(CharacterOption.allCases, id: \.self) { option in
                    Text(option.rawValue.capitalized)
                        .tag(option)
                }
            } label: {
                Text("is a...")
            }

            Picker(selection: $characterAction) {
                ForEach(CharacterAction.allCases, id: \.self) { option in
                    Text(option.rawValue.capitalized)
                        .tag(option)
                }
            } label: {
                Text("that is...")
            }

            Picker(selection: $characterLocation) {
                ForEach(CharacterLocation.allCases, id: \.self) { option in
                    Text(option.rawValue.capitalized)
                        .tag(option)
                }
            } label: {
                Text("in the...")
            }
        } header: {
            Text("Attributes")
        }
    }

    private var imageSection: some View {
        Section {
            HStack(alignment: .top, spacing: 8) {
                ZStack {
                    Text("Generate image")
                        .underline()
                        .foregroundStyle(.accent)
                        .anyButton(.plain) {
                            onGenerateImagePressed()
                        }
                        .opacity(isGenerating ? 0 : 1)

                    ProgressView()
                        .tint(.accent)
                        .opacity(isGenerating ? 1 : 0)
                }
                .disabled(isGenerating || avatarName.isEmpty)

                Circle()
                    .fill(Color.secondary.opacity(0.3))
                    .overlay(
                        ZStack {
                            if let generatedImage {
                                Image(uiImage: generatedImage)
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                    )
                    .clipShape(Circle())
            }
            .removeListRowFormatting()
        }
    }

    private var saveSection: some View {
        Section {
            AsyncCallToActionButton(
                isLoading: isSaving,
                title: "Save",
                action: onSavePressed
            )
            .removeListRowFormatting()
            .padding(.top, 24)
            .opacity(generatedImage == nil ? 0.5 : 1.0)
            .disabled(generatedImage == nil)
        }
    }

    // MARK: - Actions

    private func onBackButtonPressed() {
        dismiss()
    }

    private func onGenerateImagePressed() {
        isGenerating = true

        Task {
            do {
                let input = AvatarDescriptionBuilder(
                    characterOption: characterOption,
                    characterAction: characterAction,
                    characterLocation: characterLocation
                ).characterDescription
                generatedImage = try await aiManager.generateImage(input: input)

            } catch {
                print("Erro generating image: \(error)")
            }
            isGenerating = false
        }
    }

    private func onSavePressed() {
        guard let generatedImage else { return }
        isSaving = true

        Task {
            do {
                try TextValidationHelper.checkIfTextIsValid(text: avatarName)
                let uid = try authManager.getAuthId()

                let avatar = AvatarModel(
                    avatarId: UUID().uuidString,
                    name: avatarName,
                    profileImageName: nil,
                    characterOption: characterOption,
                    characterAction: characterAction,
                    characterLocation: characterLocation,
                    authorId: uid,
                    dateCreated: .now
                )

                try await avatarManager.createAvatar(avatar: avatar, image: generatedImage)

                dismiss()
            } catch {
                showAlert = AnyAppAlert(error: error)
            }

            isSaving = false
        }
    }
}

#Preview {
    CreateAvatarView()
        .environment(AIManager(service: MockAIService()))
        .environment(AuthManager(service: MockAuthService(user: .mock())))
        .environment(AvatarManager(service: MockAvatarService()))
}
