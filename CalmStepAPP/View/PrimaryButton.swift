//
//  PrimaryButton.swift
//  CalmSteps
//
//  the big blue pill button used across the app.
//  defining it once means restyling everywhere only takes one edit.
//

import SwiftUI

struct PrimaryButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    PrimaryButton(title: "I Understand") {
        print("tapped")
    }
}
