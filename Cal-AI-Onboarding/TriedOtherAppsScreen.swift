import SwiftUI

struct TriedOtherAppsScreen: View {
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

    @State private var selectedOptionID: Option.ID? = nil

    let steps: Int
    let currentStep: Int
    let onBack: (() -> Void)?
    let onContinue: () -> Void

    init(
        steps: Int = 4,
        currentStep: Int = 4,
        onBack: (() -> Void)? = nil,
        onContinue: @escaping () -> Void = {}
    ) {
        self.steps = steps
        self.currentStep = currentStep
        self.onBack = onBack
        self.onContinue = onContinue
    }

    var body: some View {
        OnboardingScaffold(
            steps: steps,
            currentStep: currentStep,
            title: "Have you tried other calorie tracking apps?",
            subtitle: "",
            isContinueEnabled: selectedOptionID != nil, backAction: onBack,
            continueAction: {
                if let selection = selectedOptionID,
                   let option = Option(rawValue: selection) {
                    print("Continue tapped with tried other apps selection: \(option.rawValue)")
                    onContinue()
                }
            }
        ) {
            OptionRows(options: optionRows, selectedID: $selectedOptionID)
        }
    }
}

#Preview {
    TriedOtherAppsScreen()
}
