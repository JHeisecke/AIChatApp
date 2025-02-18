//
//  OnboardingCompletedView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI

struct OnboardingCompletedView: View {

    @Environment(AppState.self) private var root
    @Environment(UserManager.self) private var userManager

    @State private var isCompletingProfileSetup = false
    var selectedColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Setup Complete!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(selectedColor)
            Text("We've set up your profile and you're ready to start chatting.")
                .font(.title)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .frame(maxHeight: .infinity)
        .safeAreaInset(edge: .bottom, content: {
            ctaButtons
        })
        .padding(24)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var ctaButtons: some View {
        ZStack {
            if isCompletingProfileSetup {
                ProgressView()
                    .tint(.white)
            } else {
                Text("Finish")
            }
        }
        .callToActionButton()
        .anyButton(.press) {
            onFinishButtonPressed()
        }
        .disabled(isCompletingProfileSetup)
    }

    func onFinishButtonPressed() {
        isCompletingProfileSetup = true
        Task {
            let hexColor = selectedColor.hexString
            try await userManager.markOnboardingCompleteForCurrentUser(profileColorHex: hexColor)
            isCompletingProfileSetup = false
            root.updateViewState(showTabBarView: true)
        }
    }
}

#Preview {
    OnboardingCompletedView(selectedColor: .mint)
        .environment(UserManager(service: MockUserServices()))
        .environment(AppState())
}
