//
//  OnboardingFlowView.swift
//  CalmSteps
//
//  owns the onboarding vm and switches between pages as the parent moves through setup
//

import SwiftUI
import SwiftData

struct OnboardingFlowView: View {
    
    @StateObject private var onboardingVM = OnboardingViewModel()
    @EnvironmentObject private var authService: AuthService
    @EnvironmentObject private var appVM: AppViewModel
    @Environment(\.modelContext) private var context
    
    var body: some View {
        Group {
            switch onboardingVM.currentPage {
                
            case .safety:
                SafetyView(onboardingVM: onboardingVM)
                
            case .accountSetup:
                AccountSetupView(onboardingVM: onboardingVM)
                
            case .createAccount:
                CreateAccountView(onboardingVM: onboardingVM, authService: authService)
                
            case .login:
                LoginView(onboardingVM: onboardingVM, authService: authService)
                
            case .dataPrivacy:
                DataPrivacyView(onboardingVM: onboardingVM)
                
            case .feature1Photos:
                FeaturePageView(
                    onboardingVM: onboardingVM,
                    icon: "photo.on.rectangle.angled",
                    iconColor: .blue,
                    title: "Personalise with Photos",
                    bodyText: "Help your child recognise tasks by using photos of their own belongings.",
                    pageIndex: 0
                )
                
            case .feature2OneStep:
                FeaturePageView(
                    onboardingVM: onboardingVM,
                    icon: "list.bullet.rectangle",
                    iconColor: .blue,
                    title: "One Step at a Time",
                    bodyText: "Big tasks feel overwhelming. We break every routine into small clear steps so your child always knows what to do next.",
                    pageIndex: 1
                )
                
            case .feature3Breaks:
                FeaturePageView(
                    onboardingVM: onboardingVM,
                    icon: "pause.circle.fill",
                    iconColor: .purple,
                    title: "Take Calm Breaks Anytime",
                    bodyText: "Sometimes things get overwhelming. Use Calm Breaks to pause any routine instantly giving your child the space to reset.",
                    pageIndex: 2
                )
                
            case .feature4Customise:
                FeaturePageView(
                    onboardingVM: onboardingVM,
                    icon: "sparkles",
                    iconColor: .teal,
                    title: "Customise it All",
                    bodyText: "Gentle visuals optional sounds and predictable screens help reduce stress for a calm experience.",
                    pageIndex: 3
                )
                
            case .feature5ParentMode:
                FeaturePageView(
                    onboardingVM: onboardingVM,
                    icon: "lock.fill",
                    iconColor: .green,
                    title: "Parent Mode Protected",
                    bodyText: "Keep routines consistent and safe. Use Parent Mode to customise tasks and track progress.",
                    pageIndex: 4
                )
                
            case .morningTime:
                MorningTimePickerView(onboardingVM: onboardingVM)
                
            case .eveningTime:
                EveningTimePickerView(onboardingVM: onboardingVM)
                
            case .setPIN:
                SetPINView(onboardingVM: onboardingVM)
            }
        }
    }
}
