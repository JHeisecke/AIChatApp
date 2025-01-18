//
//  View+ModalSupportView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-17.
//

import SwiftUI

extension View {
    func showModal(showModal: Binding<Bool>, @ViewBuilder content: () -> some View) -> some View {
        self
            .overlay {
                ModalSupportView(showModal: showModal) {
                    content()
                }
            }
    }
}
