//
//  ChatReportModel.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-02-26.
//

import Foundation

struct ChatReportModel: Codable {
    let id: String
    let chatId: String
    let reportedAvatarId: String
    let reportingUserId: String
    let isActive: Bool
    let dateCreated: Date

    enum CodingKeys: String, CodingKey {
        case id
        case chatId = "chat_id"
        case reportingUserId = "reporting_user_id"
        case reportedAvatarId = "reported_avatar_id"
        case isActive = "is_active"
        case dateCreated = "date_created"
    }

    static func new(chatId: String, reportedAvatarId: String, reportingUserId: String) -> Self {
        ChatReportModel(
            id: UUID().uuidString,
            chatId: chatId,
            reportedAvatarId: reportedAvatarId,
            reportingUserId: reportingUserId,
            isActive: true,
            dateCreated: .now
        )
    }
}
