//
//  NumWorkouts.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/11/25.
//

import SwiftUI

struct NumWorkouts: View {
    @EnvironmentObject private var onboarding: OnboardingData

    private let options: [OptionRowConfiguration<String>] = [
        OptionRowConfiguration(
            id: "0-2",
            headerText: "0-2",
            subtext: "Workouts now and then",
            image: Image("pink-gradient-sample"),
            alignment: .leading
        ),
        OptionRowConfiguration(
            id: "3-5",
            headerText: "3-5",
            subtext: "A few workouts per week",
            image: Image("pink-gradient-sample"),
            alignment: .leading
        ),
        OptionRowConfiguration(
            id: "6+",
            headerText: "6+",
            subtext: "Dedicated athlete",
            image: Image("pink-gradient-sample"),
            alignment: .leading
        )
    ]

    private var optionRows: [OptionRowConfiguration<String>] {
        options
    }

    var body: some View {
        OnboardingScaffold(
            steps: onboarding.totalSteps,
            currentStep: onboarding.currentStepNumber,
            title: "How many workouts do you do per week?",
            subtitle: "This will be used to calibrate your custom plan.",
            isContinueEnabled: onboarding.workoutsPerWeek != nil,
            backAction: onboarding.canGoBack ? { onboarding.goBack() } : nil,
            continueAction: {
                if let selection = onboarding.workoutsPerWeek {
                    print("Continue tapped with workouts: \(selection)")
                }
                onboarding.goForward()
            }
        ) {
            OptionRows(options: optionRows, selectedID: $onboarding.workoutsPerWeek)
        }
    }
}

#Preview {
    NumWorkouts()
        .environmentObject(OnboardingData())
}
