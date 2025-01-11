//
//  OnboardingIntroView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-11.
//

import SwiftUI

struct OnboardingIntroView: View {
    var body: some View {
        VStack {
            Group {
                Text("Make your own ")
                +
                Text("avatars ")
                    .foregroundStyle(.accent)
                    .fontWeight(.semibold)
                +
                Text("and chat with them!\n\nHave ")
                +
                Text("real conversations ")
                    .foregroundStyle(.accent)
                    .fontWeight(.semibold)
                +
                Text("with AI generated responses.")
            }
            .frame(maxHeight: .infinity)
            .baselineOffset(6)
            .padding(24)

            NavigationLink {
                OnboardingColorView()
            } label: {
                Text("Continue")
                    .callToActionButton()
            }
        }
        .font(.title3)
        .padding(24)
    }
}

#Preview {
    NavigationStack {
        OnboardingIntroView()
    }
}
