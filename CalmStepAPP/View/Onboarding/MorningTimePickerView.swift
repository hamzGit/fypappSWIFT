//
//  MorningTimePickerView.swift
//  CalmSteps
//
//  onboarding page where the parent picks what hour their child's morning starts.
//  the chosen hour is saved on the OnboardingViewModel.
//

import SwiftUI

struct MorningTimePickerView: View {
    
    @ObservedObject var onboardingVM: OnboardingViewModel
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                Spacer()
                
                // big yellow sun icon in a soft yellow circle
                Circle()
                    .fill(Color.yellow.opacity(0.12))
                    .frame(width: 120, height: 120)
                    .overlay {
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.yellow)
                    }
                
                Text("When does morning start?")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text("This helps us show the morning routine at the right time.")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                // wheel picker bound directly to the VM's morningHour property
                Picker("hour", selection: $onboardingVM.morningHour) {
                    ForEach(0..<24, id: \.self) { hour in
                        Text("\(hour):00").tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 140)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 40)
                
                Spacer()
                
                PrimaryButton(title: "Next") {
                    onboardingVM.goNext()
                }
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    MorningTimePickerView(onboardingVM: OnboardingViewModel())
}
