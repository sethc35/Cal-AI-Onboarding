import SwiftUI

struct TriedOtherAppsScreen: View {
    private enum Option: String, Identifiable, CaseIterable {
        case yes = "Yes"
        case no = "No"

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

    let steps = 6
    let currentStep = 4

    var body: some View {
        OnboardingScaffold(
            steps: steps,
            currentStep: currentStep,
            title: "Have you tried other calorie tracking apps?",
            subtitle: "",
            isContinueEnabled: selectedOptionID != nil,
            continueAction: {
                if let selection = selectedOptionID,
                   let option = Option(rawValue: selection) {
                    print("Continue tapped with tried other apps selection: \(option.rawValue)")
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
