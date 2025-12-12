import SwiftUI

struct HearAboutScreen: View {
    private struct SourceOption: Identifiable {
        let id = UUID()
        let title: String
    }

    private let options: [SourceOption] = [
        .init(title: "Google"),
        .init(title: "Youtube"),
        .init(title: "TikTok"),
        .init(title: "X"),
        .init(title: "App Store"),
        .init(title: "Friend or family"),
        .init(title: "TV"),
        .init(title: "Instagram"),
        .init(title: "Facebook"),
        .init(title: "Other"),
    ]

    private var optionRows: [OptionRowConfiguration<SourceOption.ID>] {
        options.map { option in
            OptionRowConfiguration(
                id: option.id,
                headerText: option.title,
                image: Image("pink-gradient-sample"),
                alignment: .leading
            )
        }
    }

    @State private var selectedID: SourceOption.ID? = nil

    let steps: Int
    let currentStep: Int
    let onBack: (() -> Void)?
    let onContinue: () -> Void

    init(
        steps: Int = 4,
        currentStep: Int = 3,
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
            title: "Where did you hear about us?",
            subtitle: "",
            scroll: true,
            isContinueEnabled: selectedID != nil, backAction: onBack,
            continueAction: {
                if let option = options.first(where: { $0.id == selectedID }) {
                    print("Continue tapped with source: \(option.title)")
                    onContinue()
                }
            }
        ) {
            OptionRows(options: optionRows, selectedID: $selectedID, isScrollable: true)
        }
    }
}

#Preview {
    HearAboutScreen()
}
