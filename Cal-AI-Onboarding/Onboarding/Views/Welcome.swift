import SwiftUI

struct Welcome: View {
    @EnvironmentObject private var onboarding: OnboardingData

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Image("pink-gradient-sample")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 24)

            VStack(spacing: 8) {
                Text("Calorie tracking")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.black)
                Text("made easy")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.black)
            }

            VStack(spacing: 12) {
                ContinueButton(isEnabled: true, title: "Get Started") {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    onboarding.startOnboarding()
                }
                .frame(height: 56)
                .padding(.horizontal, 32)

                Button("Purchased on the web? Sign In") {
                    onboarding.startOnboarding()
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    Welcome()
        .environmentObject(OnboardingData())
}
