//
//  AppView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-09.
//

import SwiftUI

struct AppView: View {

    @AppStorage("showTabBarView") var showTabBar = false

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
    }
}

#Preview {
    AppView(showTabBar: true)
}

#Preview {
    AppView(showTabBar: false)
}
