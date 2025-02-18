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
}
