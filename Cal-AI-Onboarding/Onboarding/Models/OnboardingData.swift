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
        case heightWeight
        case desiredWeight
        case birthdate
        case coachStatus
        case goal
    }

    enum MeasurementSystem: String, CaseIterable {
        case imperial
        case metric
    }

    @Published var currentStepIndex: Int = 0
    @Published var gender: String? = nil
    @Published var workoutsPerWeek: String? = nil
    @Published var hearAboutSource: String? = nil
    @Published var triedOtherAppsSelection: String? = nil
    @Published var coachStatusSelection: String? = nil
    @Published var goalSelection: String? = nil
    @Published var birthdate: Date = Date()
    @Published var measurementSystem: MeasurementSystem = .imperial
    @Published var heightInCentimeters: Double? = nil
    @Published var weightInKilograms: Double? = nil
    @Published var desiredWeightInKilograms: Double? = nil

    var totalSteps: Int { Step.allCases.count - 1 } // exclude welcome screen from progress
    var currentStepNumber: Int { max(currentStepIndex, Step.gender.rawValue) }
    var currentStep: Step { Step.allCases[currentStepIndex] }
    var canGoBack: Bool { currentStepIndex > Step.gender.rawValue }

    func startOnboarding() {
        currentStepIndex = Step.gender.rawValue
    }

    func goForward() {
        guard currentStepIndex < Step.allCases.count - 1 else {
            print("onboarding finished")
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
