//
//  DesiredWeight.swift
//  Cal-AI-Onboarding
//
//  Created by Codex on 12/14/25.
//

import SwiftUI
import UIKit

struct DesiredWeight: View {
    @EnvironmentObject private var onboarding: OnboardingData
    @State private var displayWeight: Double = 0
    @State private var startingWeightInKilograms: Double = HeightWeight.defaultWeightKilograms
    @State private var hasLoadedInitialState = false

    private let step: Double = 0.1

    private var measurementSystem: OnboardingData.MeasurementSystem {
        onboarding.measurementSystem
    }

    private var unitLabel: String {
        measurementSystem == .metric ? "kg" : "lb"
    }

    private var displayRange: ClosedRange<Double> {
        switch measurementSystem {
        case .metric:
            return 20.0...360.0
        case .imperial:
            return 50.0...700.0
        }
    }

    private var currentWeightInKilograms: Double {
        convertToKilograms(displayWeight)
    }

    private var goalDescription: String {
        let difference = currentWeightInKilograms - startingWeightInKilograms
        if abs(difference) < 0.01 {
            return "Maintain"
        } else if difference < 0 {
            return "Lose weight"
        } else {
            return "Gain weight"
        }
    }

    private var formattedWeightText: String {
        String(format: "%.1f %@", displayWeight, unitLabel)
    }

    var body: some View {
        OnboardingScaffold(
            steps: onboarding.totalSteps,
            currentStep: onboarding.currentStepNumber,
            title: "What is your desired weight?",
            subtitle: "",
            isContinueEnabled: true,
            backAction: onboarding.canGoBack ? { onboarding.goBack() } : nil,
            continueAction: {
                onboarding.desiredWeightInKilograms = currentWeightInKilograms
                onboarding.goForward()
            }
        ) {
            VStack(spacing: 18) {
                Text(goalDescription)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)

                Text(formattedWeightText)
                    .font(.system(size: 48, weight: .semibold))
                    .foregroundColor(.black)

                WeightRuler(
                    value: $displayWeight,
                    range: displayRange,
                    step: step,
                    majorTickInterval: 1,
                    baseline: baselineDisplayWeight
                )
                .frame(height: 110)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .onAppear {
                loadInitialWeightsIfNeeded()
            }
            .onChange(of: displayWeight) { newValue in
                onboarding.desiredWeightInKilograms = convertToKilograms(newValue)
            }
            .onChange(of: onboarding.measurementSystem) { _ in
                recalculateDisplayWeight()
            }
        }
    }

    private var baselineDisplayWeight: Double {
        convertToDisplay(startingWeightInKilograms)
    }

    private func convertToDisplay(_ kilograms: Double) -> Double {
        let value: Double
        switch measurementSystem {
        case .metric:
            value = kilograms
        case .imperial:
            value = kilograms * 2.20462
        }
        return clampDisplayValue((value / step).rounded() * step)
    }

    private func convertToKilograms(_ value: Double) -> Double {
        switch measurementSystem {
        case .metric:
            return value
        case .imperial:
            return value * 0.45359237
        }
    }

    private func clampDisplayValue(_ value: Double) -> Double {
        min(max(value, displayRange.lowerBound), displayRange.upperBound)
    }

    private func loadInitialWeightsIfNeeded() {
        guard !hasLoadedInitialState else { return }
        hasLoadedInitialState = true

        let recordedWeight = onboarding.weightInKilograms ?? HeightWeight.defaultWeightKilograms
        startingWeightInKilograms = recordedWeight

        let desiredWeight = onboarding.desiredWeightInKilograms ?? recordedWeight
        displayWeight = convertToDisplay(desiredWeight)
        onboarding.desiredWeightInKilograms = desiredWeight
    }

    private func recalculateDisplayWeight() {
        let kilograms = onboarding.desiredWeightInKilograms ?? onboarding.weightInKilograms ?? HeightWeight.defaultWeightKilograms
        displayWeight = convertToDisplay(kilograms)
    }
}

private struct WeightRuler: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let majorTickInterval: Double
    let baseline: Double

    @State private var isDragging = false
    @State private var dragStartValue: Double = 0
    @State private var lastHapticValue: Double = 0

    var body: some View {
        GeometryReader { geometry in
            let tickSpacing: CGFloat = 14
            let width = geometry.size.width
            let visibleTickCount = Int(width / tickSpacing) + 40
            let baseValue = snap(value)
            let midX = width / 2

            ZStack {
                if let highlight = highlightRect(
                    geometry: geometry,
                    snappedValue: snap(value),
                    snappedBaseline: snap(baseline),
                    tickSpacing: tickSpacing
                ) {
                    highlight
                }

                ForEach(0..<visibleTickCount, id: \.self) { index in
                    let delta = Double(index - visibleTickCount / 2)
                    let tickValue = baseValue + delta * step
                    if range.contains(tickValue) {
                        let xPosition = midX + CGFloat(delta) * tickSpacing
                        let isMajor = isMajorTick(tickValue)
                        let tickHeight: CGFloat = isMajor ? geometry.size.height * 0.55 : geometry.size.height * 0.3

                        Path { path in
                            let bottom = geometry.size.height - 12
                            path.move(to: CGPoint(x: xPosition, y: bottom - tickHeight))
                            path.addLine(to: CGPoint(x: xPosition, y: bottom))
                        }
                        .stroke(
                            Color.black.opacity(isMajor ? 0.8 : 0.35),
                            lineWidth: isMajor ? 1.6 : 1
                        )
                    }
                }

                Rectangle()
                    .fill(Color.black)
                    .frame(width: 2, height: geometry.size.height - 20)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        if !isDragging {
                            isDragging = true
                            dragStartValue = value
                        }
                        let deltaSteps = Double(-gesture.translation.width / tickSpacing)
                        let rawValue = dragStartValue + deltaSteps * step
                        updateValue(rawValue)
                    }
                    .onEnded { _ in
                        isDragging = false
                        value = snap(value)
                    }
            )
        }
    }

    private func updateValue(_ rawValue: Double) {
        let snapped = snap(rawValue)
        if snapped != value {
            value = snapped
            if lastHapticValue != snapped {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                lastHapticValue = snapped
            }
        }
    }

    private func snap(_ rawValue: Double) -> Double {
        let scaled = (rawValue / step).rounded()
        let snapped = scaled * step
        return min(max(snapped, range.lowerBound), range.upperBound)
    }

    private func isMajorTick(_ value: Double) -> Bool {
        let stepsPerMajor = max(Int(round(majorTickInterval / step)), 1)
        let scaledValue = Int(round(value / step))
        return scaledValue % stepsPerMajor == 0
    }
    
    private func highlightRect(
        geometry: GeometryProxy,
        snappedValue: Double,
        snappedBaseline: Double,
        tickSpacing: CGFloat
    ) -> AnyView? {
        let delta = snappedValue - snappedBaseline
        guard abs(delta) > 0.0001 else { return nil }
        let steps = abs(delta / step)
        let width = CGFloat(steps) * tickSpacing
        let height = geometry.size.height - 24
        let offset = (delta > 0 ? -width : width) / 2

        return AnyView(
            Rectangle()
                .fill(Color.black.opacity(0.12))
                .frame(width: width, height: height)
                .offset(x: offset)
        )
    }
}

#Preview {
    DesiredWeight()
        .environmentObject(OnboardingData())
}
