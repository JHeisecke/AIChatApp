//
//  MockAIService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-18.
//

import UIKit

struct MockAIService: AIService {
    func generateImage(input: String) async throws -> UIImage {
        try await Task.sleep(for: .seconds(3))
        return UIImage(systemName: "star.fill")!
    }

    func generateText(_ conversation: [AIChatModel]) async throws -> AIChatModel {
        try await Task.sleep(for: .seconds(3))
        return AIChatModel(role: .assistant, message: "This is returned text from the AI")
    }
}
