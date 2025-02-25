//
//  MockAIService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-18.
//

import UIKit

struct MockAIService: AIService {

    let delay: Double
    let showError: Bool

    init(delay: Double = 0, showError: Bool = false) {
        self.delay = delay
        self.showError = showError
    }

    private func tryShowError() throws {
        if showError {
            throw URLError(.unknown)
        }
    }

    func generateImage(input: String) async throws -> UIImage {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return UIImage(systemName: "star.fill")!
    }

    func generateText(_ conversation: [AIChatModel]) async throws -> AIChatModel {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return AIChatModel(role: .assistant, message: "This is returned text from the AI")
    }
}
