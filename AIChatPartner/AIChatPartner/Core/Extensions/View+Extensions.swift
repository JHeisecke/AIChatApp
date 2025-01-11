//
//  View+Extensions.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//
// https://www.youtube.com/watch?v=MQl4DlDf_5k&list=PLwvDm4Vfkdphc1LLLjCaEd87BEg07M97y&index=3&t=2s

import SwiftUI

extension View {
    func callToActionButton() -> some View {
        self
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.accent)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    func tappableBackground() -> some View {
        background(.black.opacity(0.001))
    }
}
