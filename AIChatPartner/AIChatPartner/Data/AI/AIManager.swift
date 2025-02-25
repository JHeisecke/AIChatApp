//
//  AIManager.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-18.
//

import SwiftUI

@MainActor
@Observable
class AIManager {
    private let service: AIService

    init(service: AIService) {
        self.service = service
    }

    func generateImage(input: String) async throws -> UIImage {
        try await service.generateImage(input: input)
    }

    func generateText(input: [AIChatModel]) async throws -> AIChatModel {
        try await service.generateText(input)
    }
}
