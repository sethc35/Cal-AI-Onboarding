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
            case .heightWeight:
                HeightWeight()
            case .birthdate:
                Birthdate()
            case .coachStatus:
                CoachStatus()
            case .goal:
                GoalSelection()
            }
        }
        .environmentObject(onboardingData)
    }
}

#Preview {
    ContentView()
}
