//
//  ContentView.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/9/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var onboardingData = OnboardingData()

    var body: some View {
        Group {
            switch onboardingData.currentStep {
            case .gender:
                GenderScreen()
            case .workouts:
                NumWorkoutsScreen()
            case .hearAbout:
                HearAboutScreen()
            case .triedOtherApps:
                TriedOtherAppsScreen()
            }
        }
        .environmentObject(onboardingData)
    }
}

#Preview {
    ContentView()
}
