//
//  GenderScreen.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/12/25.
//

import SwiftUI

struct HearAbout: View {
    @EnvironmentObject private var onboarding: OnboardingData

    private let options: [String] = [
        "Google",
        "Youtube",
        "TikTok",
        "X",
        "App Store",
        "Friend or family",
        "TV",
        "Instagram",
        "Facebook",
        "Other"
    ]

    private var optionRows: [OptionRowConfiguration<String>] {
        options.map { option in
            OptionRowConfiguration(
                id: option,
                headerText: option,
                image: Image("pink-gradient-sample"),
                alignment: .leading
            )
        }
    }

    var body: some View {
        OnboardingScaffold(
            steps: onboarding.totalSteps,
            currentStep: onboarding.currentStepNumber,
            title: "Where did you hear about us?",
            subtitle: "",
            scroll: true,
            isContinueEnabled: onboarding.hearAboutSource != nil,
            backAction: onboarding.canGoBack ? { onboarding.goBack() } : nil,
            continueAction: {
                if let source = onboarding.hearAboutSource {
                    print("Continue tapped with source: \(source)")
                }
                onboarding.goForward()
            }
        ) {
            OptionRows(options: optionRows, selectedID: $onboarding.hearAboutSource, isScrollable: true)
        }
    }
}

#Preview {
    HearAbout()
        .environmentObject(OnboardingData())
}
