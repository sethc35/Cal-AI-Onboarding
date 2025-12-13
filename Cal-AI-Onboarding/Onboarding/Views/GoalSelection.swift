//
//  GoalSelection.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/15/25.
//

import SwiftUI

struct GoalSelection: View {
    @EnvironmentObject private var onboarding: OnboardingData

    private let goals = [
        "Lose weight",
        "Maintain",
        "Gain weight"
    ]

    private var optionRows: [OptionRowConfiguration<String>] {
        goals.map { goal in
            OptionRowConfiguration(
                id: goal,
                headerText: goal,
                image: Image("pink-gradient-sample"),
                alignment: .leading
            )
        }
    }

    var body: some View {
        OnboardingScaffold(
            steps: onboarding.totalSteps,
            currentStep: onboarding.currentStepNumber,
            title: "What is your goal?",
            subtitle: "This helps us generate a plan for your calorie intake.",
            isContinueEnabled: onboarding.goalSelection != nil,
            backAction: onboarding.canGoBack ? { onboarding.goBack() } : nil,
            continueAction: {
                onboarding.goForward()
            }
        ) {
            OptionRows(options: optionRows, selectedID: $onboarding.goalSelection)
        }
    }
}

#Preview {
    GoalSelection()
        .environmentObject(OnboardingData())
}
