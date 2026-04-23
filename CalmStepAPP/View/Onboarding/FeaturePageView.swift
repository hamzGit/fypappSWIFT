//
//  FeaturePageView.swift
//  CalmSteps
//
//  Created by Hamza on 12/03/2026.
//

import SwiftUI

struct FeaturePageView: View {
    
    @ObservedObject var onboardingVM: OnboardingViewModel
    
    let icon: String
    let iconColor: Color
    let title: String
    
    //named bodyText not body because body clashes with swiftuis body property
    let bodyText: String
    
    //which dot is filled (0 to 4)
    let pageIndex: Int
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Spacer().frame(height: 20)
                
                OnboardingDots(currentIndex: pageIndex, total: 5)
                
                Spacer()
                
                Circle()
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 140, height: 140)
                    .overlay {
                        Image(systemName: icon)
                            .font(.system(size: 55))
                            .foregroundStyle(iconColor)
                    }
                
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text(bodyText)
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
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
    FeaturePageView(
        onboardingVM: OnboardingViewModel(),
        icon: "photo.on.rectangle.angled",
        iconColor: .blue,
        title: "Personalise with Photos",
        bodyText: "Help your child recognise tasks by using photos of their own belongings.",
        pageIndex: 0
    )
}
