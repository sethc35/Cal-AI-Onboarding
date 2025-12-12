import SwiftUI
internal import Combine

@MainActor
final class OnboardingData: ObservableObject {
    enum Step: Int, CaseIterable {
        case gender
        case workouts
        case hearAbout
        case triedOtherApps
    }

    @Published var currentStepIndex: Int = 0
    @Published var gender: String? = nil
    @Published var workoutsPerWeek: String? = nil
    @Published var hearAboutSource: String? = nil
    @Published var triedOtherAppsSelection: String? = nil

    var totalSteps: Int { Step.allCases.count }
    var currentStepNumber: Int { currentStepIndex + 1 }
    var currentStep: Step { Step.allCases[currentStepIndex] }
    var canGoBack: Bool { currentStepIndex > 0 }

    func goForward() {
        guard currentStepIndex < Step.allCases.count - 1 else {
            debugPrint("Onboarding complete with selections:\n- Gender: \(gender ?? "None")\n- Workouts: \(workoutsPerWeek ?? "None")\n- Heard About: \(hearAboutSource ?? "None")\n- Tried Other Apps: \(triedOtherAppsSelection ?? "None")")
            return
        }
        currentStepIndex += 1
    }

    func goBack() {
        guard canGoBack else { return }
        currentStepIndex -= 1
    }
}
