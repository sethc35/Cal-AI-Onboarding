//
//  ProgressBar.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/11/25.
//

import SwiftUI

struct ProgressBar: View {
    var currentStep: Int
    var totalSteps: Int
    var backAction: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                guard let backAction else { return }
                backAction()
            }) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "F9F8FD"))
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                }
            }
            .frame(width: 40, height: 40)
            .disabled(backAction == nil)
            .opacity(backAction == nil ? 0 : 1)
            .buttonStyle(.plain)

            GeometryReader { geo in
                let fullWidth = geo.size.width
                let segmentWidth = fullWidth / CGFloat(totalSteps)

                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 3)
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: segmentWidth * CGFloat(currentStep), height: 3)
                        .animation(.easeInOut, value: currentStep)
                }
            }
            .frame(height: 3)
        }
    }
}
