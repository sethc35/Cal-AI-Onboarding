//
//  GenderScreen.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/11/25.
//

import SwiftUI

struct GenderScreen: View {
    @EnvironmentObject private var onboarding: OnboardingData
    private let genderOptions = ["Male", "Female", "Other"]

    private var optionRows: [OptionRowConfiguration<String>] {
        genderOptions.map { option in
            OptionRowConfiguration(
                id: option,
                headerText: option,
                alignment: .center
            )
        }
    }
    
    var body: some View {
        OnboardingScaffold(
            steps: onboarding.totalSteps,
            currentStep: onboarding.currentStepNumber,
            title: "Choose your Gender",
            subtitle: "This will be used to calibrate your custom plan.",
            isContinueEnabled: onboarding.gender != nil,
            backAction: { onboarding.goBack() },
            continueAction: {
                guard let gender = onboarding.gender else { return }
                print("Continue tapped with gender: \(gender)")
                onboarding.goForward()
            }
        ) {
            OptionRows(options: optionRows, selectedID: $onboarding.gender)
        }
    }
}

#Preview {
    GenderScreen()
        .environmentObject(OnboardingData())
}
