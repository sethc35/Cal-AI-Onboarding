import SwiftUI

struct TriedOtherApps: View {
    @EnvironmentObject private var onboarding: OnboardingData

    private enum Option: String, Identifiable, CaseIterable {
        case no = "No"
        case yes = "Yes"

        var id: String { rawValue }
    }

    private var optionRows: [OptionRowConfiguration<Option.ID>] {
        Option.allCases.map { option in
            OptionRowConfiguration(
                id: option.id,
                headerText: option.rawValue,
                image: Image("pink-gradient-sample"),
                alignment: .leading
            )
        }
    }

    var body: some View {
        OnboardingScaffold(
            steps: onboarding.totalSteps,
            currentStep: onboarding.currentStepNumber,
            title: "Have you tried other calorie tracking apps?",
            subtitle: "",
            isContinueEnabled: onboarding.triedOtherAppsSelection != nil,
            backAction: onboarding.canGoBack ? { onboarding.goBack() } : nil,
            continueAction: {
                if let selection = onboarding.triedOtherAppsSelection,
                   let option = Option(rawValue: selection) {
                    print("Continue tapped with tried other apps selection: \(option.rawValue)")
                }
                onboarding.goForward()
            }
        ) {
            OptionRows(options: optionRows, selectedID: $onboarding.triedOtherAppsSelection)
        }
    }
}

#Preview {
    TriedOtherApps()
        .environmentObject(OnboardingData())
}
