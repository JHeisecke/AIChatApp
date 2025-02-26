//
//  NavigationPathOption.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-29.
//

import SwiftUI

enum NavigationPathOption: Hashable {
    case chat(avatarId: String, chat: ChatModel?)
    case category(category: CharacterOption, imageName: String)
}

extension View {
    func navigationDestionationForCoreModule(path: Binding<[NavigationPathOption]>) -> some View {
        self
            .navigationDestination(for: NavigationPathOption.self) { option in
                switch option {
                case .chat(let avatarId, let chat):
                    ChatView(avatarId: avatarId, chat: chat)
                case .category(let category, let imageName):
                    CategoryListView(path: path, category: category, imageName: imageName)
                }
            }
    }
}
