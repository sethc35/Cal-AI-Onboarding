//
//  OptionRows.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/12/25.
//

import SwiftUI

struct OptionRowConfiguration<ID: Hashable>: Identifiable {
    let id: ID
    let headerText: String
    var subtext: String? = nil
    var image: Image? = nil
    var alignment: Alignment = .leading
    var minHeight: CGFloat = 60
}

struct OptionRows<ID: Hashable>: View {
    let options: [OptionRowConfiguration<ID>]
    @Binding var selectedID: ID?
    var isScrollable: Bool = false

    var body: some View {
        VStack(spacing: 14) {
            ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                OptionRow(
                    headerText: option.headerText,
                    subtext: option.subtext,
                    image: option.image,
                    isSelected: selectedID == option.id,
                    alignment: option.alignment,
                    minHeight: option.minHeight,
                    animationDelay: Double(index) * 0.1
                )
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    selectedID = option.id
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: isScrollable ? .leading : .center)
    }
}
