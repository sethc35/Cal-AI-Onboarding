import SwiftUI

struct NumWorkoutsScreen: View {
    private struct WorkoutOption: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
    }

    private let options: [WorkoutOption] = [
        .init(title: "0-2", subtitle: "Workouts now and then"),
        .init(title: "3-5", subtitle: "A few workouts per week"),
        .init(title: "6+", subtitle: "Dedicated athlete")
    ]

    private var optionRows: [OptionRowConfiguration<WorkoutOption.ID>] {
        options.map { option in
            OptionRowConfiguration(
                id: option.id,
                headerText: option.title,
                subtext: option.subtitle,
                image: Image("pink-gradient-sample"),
                alignment: .leading
            )
        }
    }

    @State private var selectedOptionID: WorkoutOption.ID? = nil

    let steps: Int
    let currentStep: Int
    let onBack: (() -> Void)?
    let onContinue: () -> Void

    init(
        steps: Int = 4,
        currentStep: Int = 2,
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
            title: "How many workouts do you do per week?",
            subtitle: "This will be used to calibrate your custom plan.",
            isContinueEnabled: selectedOptionID != nil, backAction: onBack,
            continueAction: {
                if let option = options.first(where: { $0.id == selectedOptionID }) {
                    print("Continue tapped with workouts: \(option.title)")
                    onContinue()
                }
            }
        ) {
            OptionRows(options: optionRows, selectedID: $selectedOptionID)
        }
    }
}

#Preview {
    NumWorkoutsScreen()
}
