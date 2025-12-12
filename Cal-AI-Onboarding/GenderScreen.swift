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
            VStack(spacing: 14) {
                ForEach(Array(genderOptions.enumerated()), id: \.offset) { index, option in
                    OptionRow(
                        headerText: option,
                        isSelected: gender == option,
                        alignment: .center,
                        animationDelay: Double(index) * 0.1
                    )
                        .onTapGesture {
                            gender = option
                        }
                }
            }
        }
    }
}

#Preview {
    GenderScreen()
}
