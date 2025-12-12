//
//  OptionRow.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/10/25.
//

import SwiftUI

struct OptionRow: View {
    let headerText: String
    var subtext: String? = nil
    var image: Image? = nil
    let isSelected: Bool
    var alignment: Alignment = .center
    var minHeight: CGFloat = 60
    var animationDelay: Double = 0
    
    @State private var hasAppeared = false
    
    var body: some View {
        let textAlignment: Alignment = {
            switch alignment {
            case .center: return .center
            case .trailing: return .trailing
            default: return .leading
            }
        }()
        
        HStack(spacing: 12) {
            if let image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: subtext == nil ? 0 : 4) {
                Text(headerText)
                    .font(.system(size: 17, weight: .medium))
                if let subtext {
                    Text(subtext)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "6C6C75"))
                }
            }
            .frame(maxWidth: .infinity, alignment: textAlignment)
            .multilineTextAlignment({
                switch textAlignment {
                case .center: return .center
                case .trailing: return .trailing
                default: return .leading
                }
            }())
        }
        .frame(maxWidth: .infinity, minHeight: minHeight, alignment: alignment)
        .padding(.horizontal, 6)
        .background(isSelected ? Color.black : Color(hex: "F9F8FD"))
        .foregroundColor(isSelected ? .white : .black)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(isSelected ? 0.18 : 0), radius: isSelected ? 12 : 0, y: 6)
        .contentTransition(.opacity)
        .opacity(hasAppeared ? 1 : 0)
        .scaleEffect(hasAppeared ? 1 : 0.6)
        .animation(.spring(response: 1, dampingFraction: 0.7).delay(animationDelay), value: hasAppeared) // inital load animation
        .animation(.easeInOut(duration: 0.2), value: isSelected) // selection animation
        .onAppear {
            hasAppeared = true
        }
    }
}
