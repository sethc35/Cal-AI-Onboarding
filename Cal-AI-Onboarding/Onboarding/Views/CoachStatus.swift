//
//  CoachStatus.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/13/25.
//

import SwiftUI

struct CoachStatus: View {
    @EnvironmentObject private var onboarding: OnboardingData

    private var options: [OptionRowConfiguration<String>] {
        ["Yes", "No"].map { choice in
            OptionRowConfiguration(
                id: choice,
                headerText: choice,
                image: Image("pink-gradient-sample"),
                alignment: .leading
            )
        }
    }

    var body: some View {
        OnboardingScaffold(
            steps: onboarding.totalSteps,
            currentStep: onboarding.currentStepNumber,
            title: "Do you currently work with a personal coach or nutritionist?",
            subtitle: "",
            isContinueEnabled: onboarding.coachStatusSelection != nil,
            backAction: onboarding.canGoBack ? { onboarding.goBack() } : nil,
            continueAction: {
                onboarding.goForward()
            }
        ) {
            OptionRows(options: options, selectedID: $onboarding.coachStatusSelection)
        }
    }
}

#Preview {
    CoachStatus()
        .environmentObject(OnboardingData())
}
