//
//  AccountSetupView.swift
//  CalmSteps
//
//  Created by Hamza on 14/03/2026.
//

import SwiftUI

struct AccountSetupView: View {
    
    @ObservedObject var onboardingVM: OnboardingViewModel
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                Spacer().frame(height: 60)
                
                Circle()
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 130, height: 130)
                    .overlay {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .font(.system(size: 50))
                            .foregroundStyle(.blue)
                    }
                
                Text("Create an Account")
                    .font(.system(size: 28, weight: .bold))
                
                Spacer()
                
                PrimaryButton(title: "Create Account") {
                    onboardingVM.goToCreateAccount()
                }
                
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                    
                    Button {
                        onboardingVM.goToLogin()
                    } label: {
                        Text("Log in")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.blue)
                    }
                }
                
                //outlined button for the no-account path
                Button {
                    onboardingVM.goToDataPrivacy()
                } label: {
                    Text("Continue without an account")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.blue, lineWidth: 1.5)
                        }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
}

#Preview {
    AccountSetupView(onboardingVM: OnboardingViewModel())
}
