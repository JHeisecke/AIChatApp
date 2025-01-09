//
//  AppViewBuilder.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
// How to use generics:
// https://www.youtube.com/watch?v=rx3uRICZr5I&list=PLwvDm4Vfkdphc1LLLjCaEd87BEg07M97y&index=10
// How to use ViewBuilder:
// https://www.youtube.com/watch?v=pXmBRK1BjLw&list=PLwvDm4Vfkdphc1LLLjCaEd87BEg07M97y&index=11

import SwiftUI

struct AppViewBuilder<TabbarView: View, OnboardingView: View>: View {

    var showTabBar = false
    @ViewBuilder var tabbarView: TabbarView
    @ViewBuilder var onboardingView: OnboardingView

    var body: some View {
        ZStack {
            if showTabBar {
                tabbarView
                .transition(.move(edge: .trailing))
            } else {
                onboardingView
                .transition(.move(edge: .leading))
            }
        }
        .animation(.smooth, value: showTabBar)
    }
}

private struct PreviewView: View {
    @State private var showTabBar = false

    var body: some View {
        AppViewBuilder(
            showTabBar: showTabBar,
            tabbarView: {
                ZStack {
                    Color.red.ignoresSafeArea()
                    Text("Tabbar")
                }
            },
            onboardingView: {
                ZStack {
                    Color.blue.ignoresSafeArea()
                    Text("Onboarding")
                }
            }
        )
        .onTapGesture {
            showTabBar.toggle()
        }
    }
}

#Preview {
    PreviewView()
}
