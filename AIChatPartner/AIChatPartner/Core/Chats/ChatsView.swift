//
//  ChatsView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI

struct ChatsView: View {

    @State private var chats: [ChatModel] = ChatModel.mocks

    var body: some View {
        NavigationStack {
            List {
                ForEach(chats) { chat in
                    ChatRowCellViewBuilder(
                        currentUserId: nil,
                        chat: chat,
                        getAvatar: {
                            try? await Task.sleep(for: .seconds(1))
                            return .mock
                        },
                        getLastMessage: {
                            try? await Task.sleep(for: .seconds(1))
                            return .mock
                        }
                    )
                    .anyButton(.highlight, action: {
                        
                    })
                    .removeListRowFormatting()
                }
            }
            .navigationTitle("Chats")
        }
    }
}

#Preview {
    ChatsView()
}
