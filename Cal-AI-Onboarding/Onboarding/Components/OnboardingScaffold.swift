//
//  OnboardingScaffold.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/11/25.
//

import SwiftUI

struct OnboardingScaffold<Content: View>: View {
    let steps: Int
    let currentStep: Int
    let title: String
    let subtitle: String
    let isContinueEnabled: Bool
    let continueAction: () -> Void
    let backAction: (() -> Void)?
    let scroll: Bool
    private let content: () -> Content
    private let bottomScrollPadding: CGFloat = 160

    init(
        steps: Int,
        currentStep: Int,
        title: String,
        subtitle: String = "",
        scroll: Bool = false,
        isContinueEnabled: Bool,
        backAction: (() -> Void)? = nil,
        continueAction: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.steps = steps
        self.currentStep = currentStep
        self.title = title
        self.subtitle = subtitle
        self.scroll = scroll
        self.isContinueEnabled = isContinueEnabled
        self.backAction = backAction
        self.continueAction = continueAction
        self.content = content
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.white)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                ProgressBar(
                    currentStep: currentStep,
                    totalSteps: steps,
                    backAction: backAction
                )
                .frame(maxWidth: .infinity)
                .padding(.top, 12)

                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Group {
                    if scroll {
                        ScrollView(showsIndicators: false) {
                            content()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, bottomScrollPadding)
                        }
                    } else {
                        VStack {
                            Spacer()
                            content()
                            Spacer()
                        }
                        .padding(.bottom, bottomScrollPadding)
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: scroll ? .top : .center
                )
            }
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            bottomOverlay
        }
    }

    private var bottomOverlay: some View {
        VStack(spacing: 0) {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0),
                    Color.white.opacity(0.4),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 140)
            .allowsHitTesting(false)

            VStack {
                ContinueButton(isEnabled: isContinueEnabled, action: continueAction)
            }
            .padding(.horizontal, 14)
            .padding(.top, 18)
            .padding(.bottom, 32)
            .frame(maxWidth: .infinity)
            .background(
                Color.white
                    .ignoresSafeArea(edges: .bottom)
            )
            .overlay(
                Rectangle()
                    .fill(Color.black.opacity(0.08))
                    .frame(height: 1),
                alignment: .top
            )
        }
    }
}
