//
//  DesiredWeight.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/14/25.
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
                    .font(.system(size: 18))
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

    private let tickSpacing: CGFloat = 14
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RulerScrollView(
                    value: $value,
                    range: range,
                    step: step,
                    majorTickInterval: majorTickInterval,
                    baseline: baseline,
                    tickSpacing: tickSpacing,
                    height: geometry.size.height
                )

                Rectangle()
                    .fill(Color.black)
                    .frame(width: 2, height: geometry.size.height - 20)
            }
        }
    }

}

private struct RulerScrollView: UIViewRepresentable {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let majorTickInterval: Double
    let baseline: Double
    let tickSpacing: CGFloat
    let height: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.bounces = true
        scrollView.decelerationRate = .fast
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear

        let contentView = RulerContentView(
            config: .init(
                range: range,
                step: step,
                majorTickInterval: majorTickInterval,
                tickSpacing: tickSpacing,
                height: height
            )
        )

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = contentView.widthAnchor.constraint(equalToConstant: contentView.requiredWidth)
        widthConstraint.isActive = true

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: height)
        ])

        context.coordinator.scrollView = scrollView
        context.coordinator.contentView = contentView
        context.coordinator.widthConstraint = widthConstraint

        DispatchQueue.main.async {
            context.coordinator.updateInsetsIfNeeded()
            context.coordinator.alignScrollView(animated: false)
            contentView.updateHighlight(current: value, baseline: baseline)
        }

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.parent = self
        context.coordinator.updateContentConfiguration()
        context.coordinator.updateHighlight()
        context.coordinator.updateInsetsIfNeeded()

        if !context.coordinator.isUserInteracting {
            context.coordinator.alignScrollView(animated: false)
        }
    }

    final class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: RulerScrollView
        weak var scrollView: UIScrollView?
        weak var contentView: RulerContentView?
        weak var widthConstraint: NSLayoutConstraint?
        var isUserInteracting = false
        private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        private var lastHapticValue: Double = .nan

        init(parent: RulerScrollView) {
            self.parent = parent
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            updateSelectedValue(for: scrollView)
        }

        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            isUserInteracting = true
            feedbackGenerator.prepare()
        }

        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                isUserInteracting = false
                alignScrollView(animated: true)
            }
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            isUserInteracting = false
            alignScrollView(animated: true)
        }

        func scrollViewDidLayoutSubviews(_ scrollView: UIScrollView) {
            updateInsetsIfNeeded()
        }

        func scrollViewWillEndDragging(
            _ scrollView: UIScrollView,
            withVelocity velocity: CGPoint,
            targetContentOffset: UnsafeMutablePointer<CGPoint>
        ) {
            let inset = scrollView.contentInset.left
            let projected = targetContentOffset.pointee.x + inset
            let projectedSteps = Double(projected / parent.tickSpacing)
            let clampedSteps = clampSteps(round(projectedSteps))
            let snappedOffset = CGFloat(clampedSteps) * parent.tickSpacing - inset
            targetContentOffset.pointee.x = snappedOffset
        }

        func updateContentConfiguration() {
            guard let contentView = contentView else { return }
            let newConfig = RulerContentView.Config(
                range: parent.range,
                step: parent.step,
                majorTickInterval: parent.majorTickInterval,
                tickSpacing: parent.tickSpacing,
                height: parent.height
            )
            if contentView.config != newConfig {
                contentView.update(config: newConfig)
                widthConstraint?.constant = contentView.requiredWidth
                scrollView?.layoutIfNeeded()
            }
        }

        func updateHighlight() {
            contentView?.updateHighlight(current: parent.value, baseline: parent.baseline)
        }

        func updateInsetsIfNeeded() {
            guard let scrollView = scrollView else { return }
            let inset = max(0, scrollView.bounds.width / 2 - parent.tickSpacing / 2)
            if abs(scrollView.contentInset.left - inset) > 0.5 {
                scrollView.contentInset.left = inset
                scrollView.contentInset.right = inset
                if !isUserInteracting {
                    alignScrollView(animated: false)
                }
            }
        }

        func alignScrollView(animated: Bool) {
            guard let scrollView = scrollView else { return }
            let inset = scrollView.contentInset.left
            let clampedValue = clamp(parent.value)
            let steps = (clampedValue - parent.range.lowerBound) / parent.step
            let clampedSteps = clampSteps(steps)
            let targetX = CGFloat(clampedSteps) * parent.tickSpacing - inset
            if abs(scrollView.contentOffset.x - targetX) > 0.5 {
                scrollView.setContentOffset(CGPoint(x: targetX, y: 0), animated: animated)
            }
        }

        private func updateSelectedValue(for scrollView: UIScrollView) {
            let inset = scrollView.contentInset.left
            let offset = scrollView.contentOffset.x + inset
            let progress = Double(offset / parent.tickSpacing)
            let rawValue = parent.range.lowerBound + progress * parent.step
            
            let continuousValue = clamp(rawValue)
            let snappedValue = clamp(snap(rawValue))

            if snappedValue != lastHapticValue {
                feedbackGenerator.impactOccurred()
                lastHapticValue = snappedValue
            }
            
            if abs(parent.value - continuousValue) > 0.0001 {
                parent.value = continuousValue
                updateHighlight()
            }
        }

        private func clamp(_ value: Double) -> Double {
            min(max(value, parent.range.lowerBound), parent.range.upperBound)
        }

        private func clampSteps(_ steps: Double) -> Double {
            let maxSteps = (parent.range.upperBound - parent.range.lowerBound) / parent.step
            return min(max(steps, 0), maxSteps)
        }

        private func snap(_ rawValue: Double) -> Double {
            let scaled = (rawValue / parent.step).rounded()
            let snapped = scaled * parent.step
            return min(max(snapped, parent.range.lowerBound), parent.range.upperBound)
        }
    }
}

private final class RulerContentView: UIView {
    struct Config: Equatable {
        let range: ClosedRange<Double>
        let step: Double
        let majorTickInterval: Double
        let tickSpacing: CGFloat
        let height: CGFloat
    }

    var config: Config {
        didSet {
            if oldValue != config {
                rebuildTicks()
            }
        }
    }

    var requiredWidth: CGFloat {
        CGFloat(totalTickCount) * config.tickSpacing
    }

    private let highlightLayer = CALayer()
    private let majorLayer = CAShapeLayer()
    private let minorLayer = CAShapeLayer()

    private var totalTickCount: Int {
        max(Int(round((config.range.upperBound - config.range.lowerBound) / config.step)) + 1, 1)
    }

    init(config: Config) {
        self.config = config
        super.init(frame: .zero)
        backgroundColor = .clear
        clipsToBounds = false

        highlightLayer.backgroundColor = UIColor.black.withAlphaComponent(0.12).cgColor
        layer.addSublayer(highlightLayer)

        majorLayer.strokeColor = UIColor.black.withAlphaComponent(0.8).cgColor
        majorLayer.lineWidth = 1.6
        majorLayer.lineCap = .round

        minorLayer.strokeColor = UIColor.black.withAlphaComponent(0.35).cgColor
        minorLayer.lineWidth = 1
        minorLayer.lineCap = .round

        layer.addSublayer(minorLayer)
        layer.addSublayer(majorLayer)

        rebuildTicks()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(config: Config) {
        self.config = config
    }

    func updateHighlight(current: Double, baseline: Double) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let clampedCurrent = clamp(current)
        let snappedBaseline = snap(baseline)
        
        let startValue = min(clampedCurrent, snappedBaseline)
        let endValue = max(clampedCurrent, snappedBaseline)
        
        guard endValue - startValue > 0.0001 else {
            highlightLayer.isHidden = true
            CATransaction.commit()
            return
        }

        highlightLayer.isHidden = false
        let startX = position(for: startValue)
        let endX = position(for: endValue)
        let width = max(endX - startX, 0)
        let highlightHeight = max(config.height - 24, 0)
        let yPosition = (config.height - highlightHeight) / 2
        highlightLayer.frame = CGRect(x: startX, y: yPosition, width: width, height: highlightHeight)
        
        CATransaction.commit()
    }

    private func rebuildTicks() {
        let majorPath = UIBezierPath()
        let minorPath = UIBezierPath()
        let stepsPerMajor = max(Int(round(config.majorTickInterval / config.step)), 1)
        let bottom = config.height - 12

        for index in 0..<totalTickCount {
            let x = CGFloat(index) * config.tickSpacing + config.tickSpacing / 2
            let isMajor = index % stepsPerMajor == 0
            let tickHeight = (isMajor ? 0.55 : 0.3) * config.height
            let start = CGPoint(x: x, y: bottom - tickHeight)
            let end = CGPoint(x: x, y: bottom)

            if isMajor {
                majorPath.move(to: start)
                majorPath.addLine(to: end)
            } else {
                minorPath.move(to: start)
                minorPath.addLine(to: end)
            }
        }

        majorLayer.path = majorPath.cgPath
        minorLayer.path = minorPath.cgPath
    }

    private func position(for value: Double) -> CGFloat {
        let stepsFromStart = (clamp(value) - config.range.lowerBound) / config.step
        return CGFloat(stepsFromStart) * config.tickSpacing + config.tickSpacing / 2
    }

    private func clamp(_ value: Double) -> Double {
        min(max(value, config.range.lowerBound), config.range.upperBound)
    }

    private func snap(_ rawValue: Double) -> Double {
        let scaled = (rawValue / config.step).rounded()
        let snapped = scaled * config.step
        return clamp(snapped)
    }
}

#Preview {
    DesiredWeight()
        .environmentObject(OnboardingData())
}
