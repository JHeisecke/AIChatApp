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

    func removeListRowFormatting() -> some View {
        self
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
    }

    func addingGradientBackgroundForText() -> some View {
        self
            .background(
                LinearGradient(colors: [
                    .black.opacity(0),
                    .black.opacity(0.3),
                    .black.opacity(0.4)
                ], startPoint: .top, endPoint: .bottom)
            )
    }

    func badgeLabel() -> some View {
        self
            .font(.caption)
            .bold()
            .foregroundStyle(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 6)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 6))

    }

    @ViewBuilder
    func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
