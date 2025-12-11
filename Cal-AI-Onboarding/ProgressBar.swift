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
    
    var body: some View {
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
