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

    @State private var selectedOptionID: WorkoutOption.ID? = nil

    let steps = 6
    let currentStep = 2

    var body: some View {
        OnboardingScaffold(
            steps: steps,
            currentStep: currentStep,
            title: "How many workouts do you do per week?",
            subtitle: "This will be used to calibrate your custom plan.",
            isContinueEnabled: selectedOptionID != nil,
            continueAction: {
                if let option = options.first(where: { $0.id == selectedOptionID }) {
                    print("Continue tapped with workouts: \(option.title)")
                }
            }
        ) {
            VStack(spacing: 14) {
                ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                    OptionRow(
                        headerText: option.title,
                        subtext: option.subtitle,
                        image: Image("pink-gradient-sample"),
                        isSelected: option.id == selectedOptionID,
                        alignment: .leading,
                        animationDelay: Double(index) * 0.1
                    )
                    .onTapGesture {
                        selectedOptionID = option.id
                    }
                }
            }
        }
    }
}

#Preview {
    NumWorkoutsScreen()
}
