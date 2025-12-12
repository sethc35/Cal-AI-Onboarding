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
                ForEach(["Male", "Female", "Other"], id: \.self) { option in
                    OptionRow(headerText: option, isSelected: gender == option, alignment: .center)
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
