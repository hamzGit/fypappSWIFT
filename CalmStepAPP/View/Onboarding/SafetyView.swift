//
//  SafetyView.swift
//  CalmSteps
//
//  first screen on first launch safety disclaimer.
//  required for an app targeted at children.
//

import SwiftUI

struct SafetyView: View {
    
    @ObservedObject var onboardingVM: OnboardingViewModel
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                Spacer()
                
                // shield icon at the top
                Circle()
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 120, height: 120)
                    .overlay {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.blue)
                    }
                
                Text("Safety First")
                    .font(.system(size: 30, weight: .bold))
                
                // the two disclaimer paragraphs
                VStack(spacing: 18) {
                    Text("CalmSteps is a routine management tool, not a medical device or a substitute for professional therapy.")
                    
                    Text("This app requires adult supervision at all times during use to ensure the safety and wellbeing of the child.")
                }
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
                .padding(.horizontal, 28)
                
                Spacer()
                
                PrimaryButton(title: "I Understand") {
                    onboardingVM.goFromSafetyToAccount()
                }
                
                // footer disclaimer
                Text("By continuing, you acknowledge you have read and agreed to our safety guidelines.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    SafetyView(onboardingVM: OnboardingViewModel())
}
