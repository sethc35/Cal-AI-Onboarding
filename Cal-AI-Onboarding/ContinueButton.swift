//
//  ContinueButton.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/10/25.
//

import SwiftUI

struct ContinueButton: View {
    var isEnabled: Bool
    var action: () -> Void

    var body: some View {
        Button(action: {
            if isEnabled {
                action()
            }
        }) {
            Text("Continue")
                .font(.system(size: 18, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(isEnabled ? Color.black : Color(.systemGray4))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(isEnabled ? 0.18 : 0), radius: 12, y: 6)
                .opacity(isEnabled ? 1 : 0.8)
        }
        .disabled(!isEnabled)
        .buttonStyle(Static())
    }
}

// no click response
struct Static: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
