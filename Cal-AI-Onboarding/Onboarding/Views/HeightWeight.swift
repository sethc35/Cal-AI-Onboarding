//
//  GenderScreen.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/13/25.
//

import SwiftUI
import UIKit

struct HeightWeight: View {
    @EnvironmentObject private var onboarding: OnboardingData
    @State private var isMetric = false
    @State private var heightInCentimeters = HeightWeight.defaultHeightCentimeters
    @State private var weightInKilograms = HeightWeight.defaultWeightKilograms

    private static let defaultHeightFeet = 5
    private static let defaultHeightInches = 9
    private static let defaultWeightPounds = 155

    private static let heightCentimeterRange: ClosedRange<Int> = 60...243
    private static let weightKilogramRange: ClosedRange<Int> = 20...360
    private static let weightPoundRange: ClosedRange<Int> = 50...700
    private static let feetOptions = Array(1...8)
    private static let inchOptions = Array(0...11)

    private static var defaultHeightCentimeters: Double {
        let totalInches = Double(defaultHeightFeet * 12 + defaultHeightInches)
        return totalInches * 2.54
    }

    private static var defaultWeightKilograms: Double {
        Double(defaultWeightPounds) * 0.45359237 // round later I guess
    }

    var body: some View {
        OnboardingScaffold(
            steps: onboarding.totalSteps,
            currentStep: onboarding.currentStepNumber,
            title: "Height & weight",
            subtitle: "This will be used to calibrate your custom plan.",
            isContinueEnabled: true,
            backAction: onboarding.canGoBack ? { onboarding.goBack() } : nil,
            continueAction: {
                onboarding.goForward()
            }
        ) {
            VStack(spacing: 24) {
                unitToggle
                pickerContent
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onChange(of: isMetric, perform: syncMeasurements)
        }
    }

    private var unitToggle: some View {
        HStack(spacing: 20) {
            unitLabel("Imperial", isActive: !isMetric)
                .frame(maxWidth: .infinity)

            unitLabel("Metric", isActive: isMetric)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .font(.system(size: 18, weight: .semibold))
        .overlay(alignment: .center) {
            Toggle("", isOn: $isMetric)
                .labelsHidden()
                .tint(.black)
        }
    }

    private func unitLabel(_ text: String, isActive: Bool) -> some View {
        Text(text)
            .foregroundColor(isActive ? .black : Color.black.opacity(0.3))
            .font(.system(size: 22, weight: .semibold))
    }

    private var pickerContent: some View {
        HStack(alignment: .top, spacing: 20) {
            heightColumn
            weightColumn
        }
        .frame(maxWidth: .infinity)
    }

    private var heightColumn: some View {
        wheelContainer(title: "Height") {
            if isMetric {
                metricHeightPicker
            } else {
                HStack(spacing: 16) {
                    imperialFeetPicker
                    imperialInchesPicker
                }
            }
        }
    }

    private var imperialFeetPicker: some View {
        Picker("Feet", selection: feetBinding) {
            ForEach(Self.feetOptions, id: \.self) { value in
                MeasurementLabel(value: value, unit: "ft")
                    .tag(value)
            }
        }
        .pickerStyle(.wheel)
    }

    private var imperialInchesPicker: some View {
        Picker("Inches", selection: inchesBinding) {
            ForEach(Self.inchOptions, id: \.self) { value in
                MeasurementLabel(value: value, unit: "in")
                    .tag(value)
            }
        }
        .pickerStyle(.wheel)
    }

    private var metricHeightPicker: some View {
        Picker("Centimeters", selection: centimeterBinding) {
            ForEach(Self.heightCentimeterRange, id: \.self) { value in
                MeasurementLabel(value: value, unit: "cm")
                    .tag(value)
            }
        }
        .pickerStyle(.wheel)
    }

    private var weightColumn: some View {
        wheelContainer(title: "Weight") {
            Picker("Weight", selection: isMetric ? kilogramBinding : poundBinding) {
                if isMetric {
                    ForEach(Self.weightKilogramRange, id: \.self) { value in
                        MeasurementLabel(value: value, unit: "kg")
                            .tag(value)
                    }
                } else {
                    ForEach(Self.weightPoundRange, id: \.self) { value in
                        MeasurementLabel(value: value, unit: "lb")
                            .tag(value)
                    }
                }
            }
            .pickerStyle(.wheel)
        }
    }

    private func wheelContainer<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .center, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)

            content()
                .frame(maxWidth: .infinity, idealHeight: 190)
        }
        .frame(maxWidth: .infinity)
    }

    private var heightInInches: Double {
        heightInCentimeters / 2.54
    }

    private var feetBinding: Binding<Int> {
        Binding(
            get: {
                let roundedInches = Int(heightInInches.rounded())
                return min(max(roundedInches / 12, Self.feetOptions.first ?? 0), Self.feetOptions.last ?? 0)
            },
            set: { newFeet in
                let inches = inchesBinding.wrappedValue
                updateHeight(feet: newFeet, inches: inches)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        )
    }

    private var inchesBinding: Binding<Int> {
        Binding(
            get: {
                Int(heightInInches.rounded()) % 12
            },
            set: { newInches in
                let feet = feetBinding.wrappedValue
                updateHeight(feet: feet, inches: newInches)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        )
    }

    private var centimeterBinding: Binding<Int> {
        Binding(
            get: {
                clamp(Int(heightInCentimeters.rounded()), to: Self.heightCentimeterRange)
            },
            set: { newValue in
                heightInCentimeters = Double(clamp(newValue, to: Self.heightCentimeterRange))
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        )
    }

    private var poundBinding: Binding<Int> {
        Binding(
            get: {
                clamp(Int((weightInKilograms * 2.20462).rounded()), to: Self.weightPoundRange)
            },
            set: { newValue in
                let clamped = clamp(newValue, to: Self.weightPoundRange)
                weightInKilograms = Double(clamped) * 0.45359237
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        )
    }

    private var kilogramBinding: Binding<Int> {
        Binding(
            get: {
                clamp(Int(weightInKilograms.rounded()), to: Self.weightKilogramRange)
            },
            set: { newValue in
                let clamped = clamp(newValue, to: Self.weightKilogramRange)
                weightInKilograms = Double(clamped)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        )
    }

    private func updateHeight(feet: Int, inches: Int) {
        let boundedFeet = clamp(feet, to: (Self.feetOptions.first ?? 0)...(Self.feetOptions.last ?? 0))
        let boundedInches = clamp(inches, to: 0...11)
        let totalInches = Double(boundedFeet * 12 + boundedInches)
        heightInCentimeters = totalInches * 2.54
    }

    private func clamp<T: Comparable>(_ value: T, to range: ClosedRange<T>) -> T {
        min(max(value, range.lowerBound), range.upperBound)
    }

    private func triggerLightHaptic() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func syncMeasurements(isMetric: Bool) {
        let metricHeightRange = Double(Self.heightCentimeterRange.lowerBound)...Double(Self.heightCentimeterRange.upperBound)
        let metricWeightRange = Double(Self.weightKilogramRange.lowerBound)...Double(Self.weightKilogramRange.upperBound)
        let imperialHeightRange: ClosedRange<Double> = {
            let minFeet = Double(Self.feetOptions.first ?? 0)
            let maxFeet = Double(Self.feetOptions.last ?? 0)
            let minInches = Double(Self.inchOptions.first ?? 0)
            let maxInches = Double(Self.inchOptions.last ?? 0)
            let min = (minFeet * 12 + minInches) * 2.54
            let max = (maxFeet * 12 + maxInches) * 2.54
            return min...max
        }()
        let imperialWeightRange: ClosedRange<Double> = {
            let min = Double(Self.weightPoundRange.lowerBound) * 0.45359237
            let max = Double(Self.weightPoundRange.upperBound) * 0.45359237
            return min...max
        }()

        if isMetric {
            let feetRange = (Self.feetOptions.first ?? 0)...(Self.feetOptions.last ?? 0)
            let inchRange = (Self.inchOptions.first ?? 0)...(Self.inchOptions.last ?? 0)
            let feet = clamp(currentFeetValue, to: feetRange)
            let inches = clamp(currentInchesValue, to: inchRange)
            let totalInches = Double(feet * 12 + inches)
            let centimeters = totalInches * 2.54
            heightInCentimeters = clamp(centimeters, to: metricHeightRange)

            let pounds = clamp(currentPoundsValue, to: Self.weightPoundRange)
            let kilograms = poundsToKilograms(Double(pounds))
            weightInKilograms = clamp(kilograms, to: metricWeightRange)
        } else {
            let centimeters = Double(clamp(centimeterBinding.wrappedValue, to: Self.heightCentimeterRange))
            heightInCentimeters = clamp(centimeters, to: imperialHeightRange)

            let kilograms = Double(clamp(kilogramBinding.wrappedValue, to: Self.weightKilogramRange))
            weightInKilograms = clamp(kilograms, to: imperialWeightRange)
        }

        triggerLightHaptic()
    }

    private var currentFeetValue: Int {
        let roundedInches = Int(heightInInches.rounded())
        return roundedInches / 12
    }

    private var currentInchesValue: Int {
        Int(heightInInches.rounded()) % 12
    }

    private var currentPoundsValue: Int {
        Int((weightInKilograms * 2.20462).rounded())
    }

    private func poundsToKilograms(_ pounds: Double) -> Double {
        pounds * 0.45359237
    }

}

#Preview {
    HeightWeight()
        .environmentObject(OnboardingData())
}
