//
//  GenderScreen.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/11/25.
//

import SwiftUI

struct GenderScreen: View {
    @State private var gender: String? = nil

    let steps = 6
    let currentStep = 1
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
            steps: steps,
            currentStep: currentStep,
            title: "Choose your Gender",
            subtitle: "This will be used to calibrate your custom plan.",
            isContinueEnabled: gender != nil,
            continueAction: {
                print("Continue tapped with gender: \(gender ?? "")")
            }
        ) {
            OptionRows(options: optionRows, selectedID: $gender)
        }
    }
}

#Preview {
    GenderScreen()
}
