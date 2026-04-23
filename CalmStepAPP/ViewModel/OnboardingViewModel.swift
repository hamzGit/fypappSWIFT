//
//  OnboardingViewModel.swift
//  CalmSteps
//
//  small brain that runs the onboarding flow
//

import Foundation
import SwiftUI
import SwiftData
import Combine

final class OnboardingViewModel: ObservableObject {
    
    // each page in the onboarding flow in order
    enum Page {
        case safety
        case accountSetup
        case createAccount
        case login
        case dataPrivacy
        case feature1Photos
        case feature2OneStep
        case feature3Breaks
        case feature4Customise
        case feature5ParentMode
        case morningTime
        case eveningTime
        case setPIN
    }
    
    @Published var currentPage: Page = .safety
    
    // the parents choices held in memory until they finish
    @Published var morningHour: Int = 6
    @Published var eveningHour: Int = 17
    @Published var chosenPIN: String = ""
    @Published var isGuestMode: Bool = false
    
    func goFromSafetyToAccount() {
        currentPage = .accountSetup
    }
    
    func goToCreateAccount() {
        currentPage = .createAccount
    }
    
    func goToLogin() {
        currentPage = .login
    }
    
    func goToDataPrivacy() {
        isGuestMode = true
        currentPage = .dataPrivacy
    }
    
    // all three paths (firebase signup, login, guest) merge here
    func startFeatureWalkthrough() {
        currentPage = .feature1Photos
    }
    
    func goNext() {
        if currentPage == .feature1Photos {
            currentPage = .feature2OneStep
        } else if currentPage == .feature2OneStep {
            currentPage = .feature3Breaks
        } else if currentPage == .feature3Breaks {
            currentPage = .feature4Customise
        } else if currentPage == .feature4Customise {
            currentPage = .feature5ParentMode
        } else if currentPage == .feature5ParentMode {
            currentPage = .morningTime
        } else if currentPage == .morningTime {
            currentPage = .eveningTime
        } else if currentPage == .eveningTime {
            currentPage = .setPIN
        }
    }
    
    func finishOnboarding(context: ModelContext, appVM: AppViewModel) {
        
        let descriptor = FetchDescriptor<AppSettings>()
        let allSettings = (try? context.fetch(descriptor)) ?? []
        var settings = allSettings.first
        
        //no settings record yet so make one
        if settings == nil {
            let newSettings = AppSettings()
            context.insert(newSettings)
            settings = newSettings
        }
        
        settings!.morningStartHour = morningHour
        settings!.eveningStartHour = eveningHour
        settings!.savedPIN = chosenPIN
        settings!.hasSetPIN = true
        settings!.hasCompletedOnboarding = true
        settings!.isGuestMode = isGuestMode
        
        try? context.save()
        
        appVM.finishOnboarding()
    }
}
