//
//  MeasurementLabel.swift
//  Cal-AI-Onboarding
//
//  Created by Seth Chang on 12/13/25.
//

import SwiftUI

struct MeasurementLabel: View {
    let value: Int
    let unit: String

    var body: some View {
        Text("\(value) \(unit)")
            .foregroundColor(.black)
    }
}
