//
//  AIService.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-18.
//

import SwiftUI

protocol AIService: Sendable {
    func generateImage(input: String) async throws -> UIImage
}
