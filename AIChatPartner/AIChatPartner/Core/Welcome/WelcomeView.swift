//
//  WelcomeView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI

struct WelcomeView: View {

    @State var imageName = Constants.randomImage

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                ImageLoaderView(urlString: imageName)
                    .ignoresSafeArea()

                titleSection
                    .padding(.top, 24)

                buttons
                    .padding(16)
            }
        }
    }

    private var titleSection: some View {
        VStack {
            Text("Chat Partner 🤠")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("JHeisecke")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var buttons: some View {
        VStack(spacing: 20) {
            NavigationLink {
                OnboardingIntroView()
            } label: {
                Text("Get Started")
                    .callToActionButton()
            }
            Text("Already have an account? Sign in.")
                .tappableBackground()
                .underline()
                .foregroundStyle(.black)
                .onTapGesture {

                }

            HStack {
                Link(destination: URL(string: Constants.termsOfServiceURL)!) {
                    Text("Terms of Service")
                }
                Circle()
                    .frame(width: 4, height: 4)
                Link(destination: URL(string: Constants.privacyPolicyURL)!) {
                    Text("Privacy Policy")
                }
            }
            .foregroundStyle(.accent)
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
