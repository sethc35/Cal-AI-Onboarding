//
//  OptionRow.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/10/25.
//

import SwiftUI

struct OptionRow: View {
    let title: String
    let isSelected: Bool
    var alignment: Alignment = .center
    
    var body: some View {
        Text(title)
            .font(.system(size: 17, weight: .medium))
            .frame(maxWidth: .infinity, minHeight: 60, alignment: alignment)
            .padding(.horizontal, 12)
            .background(isSelected ? Color.black : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .black)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(isSelected ? 0.18 : 0), radius: isSelected ? 12 : 0, y: 6)
            .contentTransition(.opacity)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
