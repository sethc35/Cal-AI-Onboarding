//
//  GenderScreen.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/11/25.
//

import SwiftUI

struct GenderScreen: View {
    @State private var gender: String? = nil

    let steps: Int
    let currentStep: Int
    let onBack: (() -> Void)?
    let onContinue: () -> Void
    private let genderOptions = ["Male", "Female", "Other"]

    init(
        steps: Int = 4,
        currentStep: Int = 1,
        onBack: (() -> Void)? = nil,
        onContinue: @escaping () -> Void = {}
    ) {
        self.steps = steps
        self.currentStep = currentStep
        self.onBack = onBack
        self.onContinue = onContinue
    }

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
            steps: steps,
            currentStep: currentStep,
            title: "Choose your Gender",
            subtitle: "This will be used to calibrate your custom plan.",
            isContinueEnabled: gender != nil, backAction: onBack,
            continueAction: {
                guard let gender else { return }
                print("Continue tapped with gender: \(gender)")
                onContinue()
            }
        ) {
            OptionRows(options: optionRows, selectedID: $gender)
        }
    }
}

#Preview {
    GenderScreen()
}
