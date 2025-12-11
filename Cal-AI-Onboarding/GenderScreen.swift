//
//  ContinueButton.swift
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
        ZStack {
            Color(.white)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                ProgressBar(currentStep: currentStep, totalSteps: steps)
                    .frame(height: 3)
                    .padding(.top, 12)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Choose your Gender")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.black)

                    Text("This will be used to calibrate your custom plan.")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                VStack(spacing: 14) {
                    ForEach(["Male", "Female", "Other"], id: \.self) { option in
                        OptionRow(headerText: option, isSelected: gender == option, alignment: .center)
                            .onTapGesture {
                                gender = option
                            }
                    }
                }

                Spacer()

                ContinueButton(isEnabled: gender != nil) {
                    print("Continue tapped with gender: \(gender ?? "")")
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 28)
        }
    }
}

#Preview {
    GenderScreen()
}
