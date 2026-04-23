//
//  OnboardingDots.swift
//  CalmSteps
//
//  Created by Hamza on 12/03/2026.
//

import SwiftUI

struct OnboardingDots: View {
    
    //which dot is currently filled (0 = first)
    let currentIndex: Int
    
    //how many dots to show in total
    let total: Int
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<total, id: \.self) { index in
                dot(index: index)
            }
        }
    }
    
    //one pill dot- wider + solid blue if its the current one
    private func dot(index: Int) -> some View {
        
        var width: CGFloat = 22
        var fillColor = Color.blue.opacity(0.25)
        
        if index == currentIndex {
            width = 32
            fillColor = Color.blue
        }
        
        return Capsule()
            .fill(fillColor)
            .frame(width: width, height: 6)
    }
}

#Preview {
    VStack(spacing: 20) {
        OnboardingDots(currentIndex: 0, total: 5)
        OnboardingDots(currentIndex: 2, total: 5)
        OnboardingDots(currentIndex: 4, total: 5)
    }
    .padding()
}
