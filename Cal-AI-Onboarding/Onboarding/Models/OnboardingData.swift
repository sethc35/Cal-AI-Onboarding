//
//  OnboardingData.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/12/25.
//

import SwiftUI
internal import Combine

@MainActor
final class OnboardingData: ObservableObject {
    enum Step: Int, CaseIterable {
        case welcome
        case gender
        case workouts
        case hearAbout
        case triedOtherApps
        case results
    }

    @Published var currentStepIndex: Int = 0
    @Published var gender: String? = nil
    @Published var workoutsPerWeek: String? = nil
    @Published var hearAboutSource: String? = nil
    @Published var triedOtherAppsSelection: String? = nil

    var totalSteps: Int { Step.allCases.count - 1 } // exclude welcome screen from progress
    var currentStepNumber: Int { max(currentStepIndex, Step.gender.rawValue) }
    var currentStep: Step { Step.allCases[currentStepIndex] }
    var canGoBack: Bool { currentStepIndex > Step.gender.rawValue }

    func startOnboarding() {
        currentStepIndex = Step.gender.rawValue
    }

    func goForward() {
        guard currentStepIndex < Step.allCases.count - 1 else {
            debugPrint("Onboarding complete with selections:\n- Gender: \(gender ?? "None")\n- Workouts: \(workoutsPerWeek ?? "None")\n- Heard About: \(hearAboutSource ?? "None")\n- Tried Other Apps: \(triedOtherAppsSelection ?? "None")")
            return
        }
        currentStepIndex += 1
    }

    func goBack() {
        if currentStepIndex == Step.gender.rawValue {
            currentStepIndex = Step.welcome.rawValue
        } else if canGoBack {
            currentStepIndex -= 1
        }
    }
}
