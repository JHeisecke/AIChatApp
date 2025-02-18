//
//  OpenAIService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-18.
//

import SwiftUI
import OpenAI

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
}

enum OpenAIError: LocalizedError {
    case invalidResponse
}
