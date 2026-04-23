//
//  DataPrivacyView.swift
//  CalmSteps
//
//  shown when parent picks continue without an account
//

import SwiftUI

struct DataPrivacyView: View {
    
    @ObservedObject var onboardingVM: OnboardingViewModel
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Spacer().frame(height: 30)
                
                Text("Data Privacy")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Circle()
                    .fill(Color.teal.opacity(0.20))
                    .frame(width: 140, height: 140)
                    .overlay {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 55))
                            .foregroundStyle(.teal)
                    }
                
                Text("Use Without an Account")
                    .font(.system(size: 26, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                // 3 info cards same pattern repeated
                VStack(spacing: 12) {
                    infoCard(
                        icon: "iphone",
                        iconColor: .blue,
                        title: "Device Storage",
                        subtitle: "All data stays on this device"
                    )
                    infoCard(
                        icon: "eye.slash.fill",
                        iconColor: .green,
                        title: "Privacy First",
                        subtitle: "Nothing is shared or uploaded"
                    )
                    infoCard(
                        icon: "key.fill",
                        iconColor: .orange,
                        title: "No Recovery",
                        subtitle: "If you forget your PIN it cant be recovered"
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    onboardingVM.startFeatureWalkthrough()
                }
                .padding(.bottom, 24)
            }
        }
    }
    
    private func infoCard(icon: String,
                          iconColor: Color,
                          title: String,
                          subtitle: String) -> some View {
        HStack(spacing: 14) {
            Circle()
                .fill(iconColor.opacity(0.18))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: icon)
                        .foregroundStyle(iconColor)
                }
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(Color.blue.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    DataPrivacyView(onboardingVM: OnboardingViewModel())
}
