//
//  EveningTimePickerView.swift
//  CalmSteps
//


import SwiftUI

struct EveningTimePickerView: View {
    
    @ObservedObject var onboardingVM: OnboardingViewModel
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                Spacer()
                
                Circle()
                    .fill(Color.indigo.opacity(0.12))
                    .frame(width: 120, height: 120)
                    .overlay {
                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.indigo)
                    }
                
                Text("When does evening start?")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text("We'll switch to the evening routine after this time.")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                //wheel picker bound to onboardingVM.eveningHour, 0-23
                Picker("hour", selection: $onboardingVM.eveningHour) {
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
    EveningTimePickerView(onboardingVM: OnboardingViewModel())
}
