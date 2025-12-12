//
//  ContentView.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/9/25.
//

import SwiftUI

struct ContentView: View {
    private enum OnboardingStep: Int, CaseIterable {
        case gender
        case workouts
        case hearAbout
        case triedOtherApps
    }

    private let orderedSteps = OnboardingStep.allCases
    @State private var currentStepIndex = 0

    var body: some View {
        let totalSteps = orderedSteps.count
        let step = orderedSteps[currentStepIndex]
        let backAction: (() -> Void)? = currentStepIndex > 0 ? { goBack() } : nil

        Group {
            switch step {
            case .gender:
                GenderScreen(
                    steps: totalSteps,
                    currentStep: currentStepIndex + 1,
                    onBack: backAction,
                    onContinue: advance
                )
            case .workouts:
                NumWorkoutsScreen(
                    steps: totalSteps,
                    currentStep: currentStepIndex + 1,
                    onBack: backAction,
                    onContinue: advance
                )
            case .hearAbout:
                HearAboutScreen(
                    steps: totalSteps,
                    currentStep: currentStepIndex + 1,
                    onBack: backAction,
                    onContinue: advance
                )
            case .triedOtherApps:
                TriedOtherAppsScreen(
                    steps: totalSteps,
                    currentStep: currentStepIndex + 1,
                    onBack: backAction,
                    onContinue: advance
                )
            }
        }
    }

    private func advance() {
        if currentStepIndex < orderedSteps.count - 1 {
            currentStepIndex += 1
        } else {
            print("Onboarding complete")
        }
    }

    private func goBack() {
        if currentStepIndex > 0 {
            currentStepIndex -= 1
        }
    }
}

#Preview {
    ContentView()
}
