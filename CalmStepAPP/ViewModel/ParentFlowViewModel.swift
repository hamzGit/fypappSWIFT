//
//  ParentFlowViewModel.swift
//  CalmSteps
//
//  brain for the parent world.


import Foundation
import SwiftUI
import LocalAuthentication
import SwiftData
import Combine

final class ParentFlowViewModel: ObservableObject {
    
    enum Screen {
        case pin
        case dashboard
        case routines
        case settings
        case insights
        case help
        case childPreview
    }
    
    @Published var currentScreen: Screen = .pin
    @Published var enteredPIN: String = ""
    @Published var pinError: String? = nil
    
    private var autoLockTimer: Timer?
    
    // ---- pin keypad ----
    
    func addDigit(_ digit: String, context: ModelContext) {
        if enteredPIN.count >= 4 { return }
        enteredPIN.append(digit)
        pinError = nil
        if enteredPIN.count == 4 {
            checkPIN(context: context)
        }
    }
    
    func removeDigit() {
        if enteredPIN.isEmpty { return }
        enteredPIN.removeLast()
        pinError = nil
    }
    
    func clearPIN() {
        enteredPIN = ""
        pinError = nil
    }
    
    private func checkPIN(context: ModelContext) {
        let descriptor = FetchDescriptor<AppSettings>()
        let allSettings = (try? context.fetch(descriptor)) ?? []
        
        var savedPIN = ""
        if allSettings.first != nil {
            savedPIN = allSettings.first!.savedPIN
        }
        
        if enteredPIN == savedPIN {
            enteredPIN = ""
            pinError = nil
            currentScreen = .dashboard
        } else {
            pinError = "Wrong PIN. Try again."
            enteredPIN = ""
        }
    }
    

    
    // face id runs on a background thread so we need DispatchQueue.main.async
    // to update the published property safely
    func tryFaceID() {
        let biometricContext = LAContext()
        var error: NSError? = nil
        
        let canUse = biometricContext.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        )
        
        if canUse == false { return }
        
        biometricContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Unlock Parent Mode"
        ) { success, _ in
            DispatchQueue.main.async {
                if success == true {
                    self.currentScreen = .dashboard
                }
            }
        }
    }
    

    
    func resetAutoLock(minutes: Int) {
        stopAutoLock()
        if currentScreen == .pin { return }
        let seconds = Double(minutes * 60)
        autoLockTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] _ in
            self?.lock()
        }
    }
    
    func stopAutoLock() {
        autoLockTimer?.invalidate()
        autoLockTimer = nil
    }
    
    func lock() {
        stopAutoLock()
        clearPIN()
        currentScreen = .pin
    }
    

    
    func goToDashboard()    { currentScreen = .dashboard    }
    func goToRoutines()     { currentScreen = .routines     }
    func goToSettings()     { currentScreen = .settings     }
    func goToInsights()     { currentScreen = .insights     }
    func goToHelp()         { currentScreen = .help         }
    func goToChildPreview() { currentScreen = .childPreview }
}
