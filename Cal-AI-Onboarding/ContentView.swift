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
            case .welcome:
                Welcome()
            case .gender:
                Gender()
            case .workouts:
                NumWorkouts()
            case .hearAbout:
                HearAbout()
            case .triedOtherApps:
                TriedOtherApps()
            case .results:
                LongTermResults()
            }
        }
        .animation(.easeInOut, value: onboardingData.currentStep)
        .environmentObject(onboardingData)
    }
}

#Preview {
    ContentView()
}
