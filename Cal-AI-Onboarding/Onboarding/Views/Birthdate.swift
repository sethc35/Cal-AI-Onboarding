//
//  Birthdate.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/13/25.
//

import SwiftUI

struct Birthdate: View {
    @EnvironmentObject private var onboarding: OnboardingData
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedDay = Calendar.current.component(.day, from: Date())
    @State private var selectedYear = Calendar.current.component(.year, from: Date())

    private let months = Calendar.current.monthSymbols
    private let monthRange = Array(1...12)
    private let yearRange: [Int] = {
        let calendar = Calendar.current
        let maxYear = 2030 // subject to change - just using this for semantics
        return Array(1900...maxYear)
    }()

    var body: some View {
        OnboardingScaffold(
            steps: onboarding.totalSteps,
            currentStep: onboarding.currentStepNumber,
            title: "When were you born?",
            subtitle: "This will be used to calibrate your custom plan.",
            isContinueEnabled: true,
            backAction: onboarding.canGoBack ? { onboarding.goBack() } : nil,
            continueAction: saveAndContinue
        ) {
            HStack(spacing: 16) {
                monthPicker
                dayPicker
                yearPicker
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear(perform: syncFromOnboarding)
        .onChange(of: selectedMonth) { clampDay() }
        .onChange(of: selectedYear) { clampDay() }
    }

    private var monthPicker: some View {
        Picker("Month", selection: $selectedMonth) {
            ForEach(monthRange, id: \.self) { month in
                wheelText(months[month - 1])
                    .tag(month)
            }
        }
        .pickerStyle(.wheel)
    }

    private var dayPicker: some View {
        Picker("Day", selection: $selectedDay) {
            ForEach(days, id: \.self) { day in
                wheelText("\(day)")
                    .tag(day)
            }
        }
        .pickerStyle(.wheel)
    }

    private var yearPicker: some View {
        Picker("Year", selection: $selectedYear) {
            ForEach(yearRange, id: \.self) { year in
                wheelText("\(year)")
                    .tag(year)
            }
        }
        .pickerStyle(.wheel)
    }

    private var days: [Int] {
        let calendar = Calendar.current
        var components = DateComponents()
        components.month = selectedMonth
        components.year = selectedYear

        guard
            let date = calendar.date(from: components),
            let range = calendar.range(of: .day, in: .month, for: date)
        else {
            return Array(1...31)
        }
        return Array(range)
    }

    private func clampDay() {
        guard let maxDay = days.last else { return }
        if selectedDay > maxDay {
            selectedDay = maxDay
        }
    }

    private func wheelText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 16))
            .foregroundColor(.black)
    }

    private func syncFromOnboarding() {
        let calendar = Calendar.current
        let date = onboarding.birthdate
        selectedMonth = calendar.component(.month, from: date)
        selectedDay = calendar.component(.day, from: date)
        selectedYear = calendar.component(.year, from: date)
    }

    private func saveAndContinue() {
        var components = DateComponents()
        components.month = selectedMonth
        components.day = selectedDay
        components.year = selectedYear
        if let date = Calendar.current.date(from: components) {
            onboarding.birthdate = date
        }
        onboarding.goForward()
    }
}

#Preview {
    Birthdate()
        .environmentObject(OnboardingData())
}
