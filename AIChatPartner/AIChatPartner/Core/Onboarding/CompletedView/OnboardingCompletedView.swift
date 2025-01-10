//
//  OnboardingCompletedView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI

struct OnboardingCompletedView: View {

    @Environment(AppState.self) private var root

    var body: some View {
        NavigationStack {
            VStack {
                Text("Onboarding Completed!")

                Button {
                    onFinishButtonPressed()
                } label: {
                    Text("Finish")
                        .callToActionButton()
                }
            }
            .padding(16)
        }
    }

    func onFinishButtonPressed() {
        root.updateViewState(showTabBarView: true)
    }
}

#Preview {
    OnboardingCompletedView()
        .environment(AppState())
}
