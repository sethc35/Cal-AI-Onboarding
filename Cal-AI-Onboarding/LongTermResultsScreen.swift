import SwiftUI

struct LongTermResultsScreen: View {
    @EnvironmentObject private var onboarding: OnboardingData
    @State private var showCaption = false

    var body: some View {
        OnboardingScaffold(
            steps: onboarding.totalSteps,
            currentStep: onboarding.currentStepNumber,
            title: "Cal AI creates\nlong-term results",
            subtitle: "",
            isContinueEnabled: true,
            backAction: onboarding.canGoBack ? { onboarding.goBack() } : nil,
            continueAction: {
                onboarding.goForward()
            }
        ) {
            VStack(spacing: 24) {
                resultCard
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) {
                    showCaption = true
                }
            }
        }
    }

    private var resultCard: some View {
        VStack(spacing: 16) {
            Text("Your weight")
                .font(.system(size: 24))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)

            Image("pink-gradient-sample")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            caption
                }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "F4F4F6"))
        .cornerRadius(20)
    }

    private var caption: some View {
        VStack(spacing: 4) {
            captionLine("80% of Cal AI users maintain their", index: 0)
            captionLine("weight loss even 6 months later", index: 1)
        }
        .frame(maxWidth: .infinity)
    }

    private func captionLine(_ text: String, index: Int) -> some View {
        Text(text)
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(.black)
            .opacity(showCaption ? 1 : 0)
            .offset(y: showCaption ? 0 : 12)
            .animation(.easeOut(duration: 0.35).delay(Double(index) * 0.2), value: showCaption)
    }
}

#Preview {
    LongTermResultsScreen()
        .environmentObject(OnboardingData())
}
