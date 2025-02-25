//
//  OpenAIService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-18.
//

import SwiftUI
import OpenAI

typealias ChatContent = ChatQuery.ChatCompletionMessageParam.UserMessageParam.Content.VisionContent
typealias ChatText = ChatQuery.ChatCompletionMessageParam.UserMessageParam.Content.VisionContent.ChatCompletionContentPartTextParam

struct OpenAIService: AIService {

    var openAI: OpenAI {
        OpenAI(apiToken: Keys.openAIKey)
    }

    func generateImage(input: String) async throws -> UIImage {
        let query = ImagesQuery(
            prompt: input,
            n: 1,
            quality: .hd,
            responseFormat: .b64_json,
            size: ._512,
            style: .natural,
            user: nil
        )
        let result = try await openAI.images(query: query)

        guard let jsonData = result.data.first?.b64Json,
              let data = Data(base64Encoded: jsonData),
              let image = UIImage(data: data)
        else {
            throw OpenAIError.invalidResponse
        }
        return image
    }

    func generateText(_ conversation: [AIChatModel]) async throws -> AIChatModel {
        let messages = conversation.compactMap({ $0.toOpenAIModel() })

        let query = ChatQuery(
            messages: messages,
            model: .gpt3_5Turbo
        )
        let result = try await openAI.chats(query: query)

        guard
            let chat = result.choices.first?.message,
            let model = chat.toModel()
        else {
            throw OpenAIError.invalidResponse
        }
        return model
    }
}

enum OpenAIError: LocalizedError {
    case invalidResponse
}

struct AIChatModel {
    let role: Role
    let message: String

    enum Role {
        case system, user, assistant, tool, developer
    }
}

extension AIChatModel {
    func toOpenAIModel() -> ChatQuery.ChatCompletionMessageParam? {
        ChatQuery.ChatCompletionMessageParam(
            role: getOpenAIRole(),
            content: message
        )
    }

    func getOpenAIRole() -> ChatQuery.ChatCompletionMessageParam.Role {
        return switch role {
        case .tool:
            .tool
        case .assistant:
            .assistant
        case .system:
            .system
        case .user:
            .user
        case .developer:
            .developer
        }
    }
}

extension ChatResult.Choice.ChatCompletionMessage {
    func toModel() -> AIChatModel? {
        guard let message = self.content?.string else { return nil }
        let role = switch self.role {
        case .system:
            AIChatModel.Role.system
        case .developer:
            AIChatModel.Role.developer
        case .user:
            AIChatModel.Role.user
        case .assistant:
            AIChatModel.Role.assistant
        case .tool:
            AIChatModel.Role.tool
        }
        return .init(role: role, message: message)
    }
}
