//
//  SetPINView.swift
//  CalmSteps
//
//  two pass pin setup - first pick it then confirm it
//

import SwiftUI
import SwiftData

struct SetPINView: View {
    
    @ObservedObject var onboardingVM: OnboardingViewModel
    @EnvironmentObject private var appVM: AppViewModel
    @Environment(\.modelContext) private var context
    
    @State private var firstPIN: String = ""
    @State private var typed: String = ""
    @State private var isConfirming: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Spacer().frame(height: 20)
                
                Circle()
                    .fill(Color.green.opacity(0.12))
                    .frame(width: 100, height: 100)
                    .overlay {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.green)
                    }
                
                Text(titleText)
                    .font(.system(size: 26, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text(subtitleText)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                // 4 dots fill up as digits are typed
                HStack(spacing: 16) {
                    pinDot(index: 0)
                    pinDot(index: 1)
                    pinDot(index: 2)
                    pinDot(index: 3)
                }
                .padding(.vertical, 10)
                
                if errorMessage != nil {
                    Text(errorMessage!)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
                
                Spacer()
                
                keypad
                
                Spacer().frame(height: 20)
            }
        }
    }
    
    private func pinDot(index: Int) -> some View {
        let isFilled = index < typed.count
        return Circle()
            .fill(isFilled ? Color.blue : Color.gray.opacity(0.25))
            .frame(width: 18, height: 18)
    }
    
    // every button placed by hand so its clear whats on screen
    private var keypad: some View {
        VStack(spacing: 14) {
            HStack(spacing: 14) {
                keypadButton(label: "1") { addDigit("1") }
                keypadButton(label: "2") { addDigit("2") }
                keypadButton(label: "3") { addDigit("3") }
            }
            HStack(spacing: 14) {
                keypadButton(label: "4") { addDigit("4") }
                keypadButton(label: "5") { addDigit("5") }
                keypadButton(label: "6") { addDigit("6") }
            }
            HStack(spacing: 14) {
                keypadButton(label: "7") { addDigit("7") }
                keypadButton(label: "8") { addDigit("8") }
                keypadButton(label: "9") { addDigit("9") }
            }
            HStack(spacing: 14) {
                // invisible placeholder keeps 0 centred
                Color.clear.frame(maxWidth: .infinity).frame(height: 64)
                keypadButton(label: "0") { addDigit("0") }
                keypadButton(label: "⌫") { removeDigit() }
            }
        }
        .padding(.horizontal, 40)
    }
    
    private func keypadButton(label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 26, weight: .medium))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var titleText: String {
        return isConfirming ? "Confirm your PIN" : "Set a Parent PIN"
    }
    
    private var subtitleText: String {
        return isConfirming ? "Enter the same 4 digits again" : "Choose 4 digits to protect Parent Mode"
    }
    
    private func addDigit(_ digit: String) {
        if typed.count >= 4 { return }
        errorMessage = nil
        typed = typed + digit
        if typed.count == 4 {
            handleFourDigitsTyped()
        }
    }
    
    private func removeDigit() {
        if typed.isEmpty { return }
        typed.removeLast()
        errorMessage = nil
    }
    
    // first pass saves the pin second pass checks it matches
    private func handleFourDigitsTyped() {
        if isConfirming == false {
            firstPIN = typed
            typed = ""
            isConfirming = true
            return
        }
        if typed == firstPIN {
            onboardingVM.chosenPIN = typed
            onboardingVM.finishOnboarding(context: context, appVM: appVM)
        } else {
            errorMessage = "PINs did not match. Please try again."
            typed = ""
            firstPIN = ""
            isConfirming = false
        }
    }
}

#Preview {
    SetPINView(onboardingVM: OnboardingViewModel())
        .environmentObject(AppViewModel())
}
