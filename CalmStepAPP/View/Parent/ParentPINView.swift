//
//  ParentPINView.swift
//  CalmSteps
//
//  the 4-digit pin keypad parent types their pin to unlock parent mode
//

import SwiftUI
import SwiftData

struct ParentPINView: View {
    
    @ObservedObject var parentVM: ParentFlowViewModel
    @Environment(\.modelContext) private var context
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 18) {
                
                Spacer().frame(height: 30)
                
                Circle()
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 90, height: 90)
                    .overlay {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.blue)
                    }
                
                Text("Parent PIN")
                    .font(.system(size: 28, weight: .bold))
                
                Text("Enter your 4-digit PIN to access Parent Mode")
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)
                
                // 4 dots that fill up as digits are typed
                HStack(spacing: 16) {
                    pinDot(index: 0)
                    pinDot(index: 1)
                    pinDot(index: 2)
                    pinDot(index: 3)
                }
                .padding(.vertical, 8)
                
                if parentVM.pinError != nil {
                    Text(parentVM.pinError!)
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
        var isFilled = false
        if index < parentVM.enteredPIN.count {
            isFilled = true
        }
        var dotColor = Color.gray.opacity(0.25)
        if isFilled == true {
            dotColor = Color.blue
        }
        return Circle()
            .fill(dotColor)
            .frame(width: 18, height: 18)
    }
    
    // every button placed by hand so its clear whats on screen
    private var keypad: some View {
        VStack(spacing: 14) {
            
            HStack(spacing: 14) {
                keypadButton(label: "1") { parentVM.addDigit("1", context: context) }
                keypadButton(label: "2") { parentVM.addDigit("2", context: context) }
                keypadButton(label: "3") { parentVM.addDigit("3", context: context) }
            }
            
            HStack(spacing: 14) {
                keypadButton(label: "4") { parentVM.addDigit("4", context: context) }
                keypadButton(label: "5") { parentVM.addDigit("5", context: context) }
                keypadButton(label: "6") { parentVM.addDigit("6", context: context) }
            }
            
            HStack(spacing: 14) {
                keypadButton(label: "7") { parentVM.addDigit("7", context: context) }
                keypadButton(label: "8") { parentVM.addDigit("8", context: context) }
                keypadButton(label: "9") { parentVM.addDigit("9", context: context) }
            }
            
            HStack(spacing: 14) {
                // invisible placeholder keeps 0 centred
                Color.clear
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                keypadButton(label: "0") { parentVM.addDigit("0", context: context) }
                keypadButton(label: "⌫") { parentVM.removeDigit() }
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
}

#Preview {
    ParentPINView(parentVM: ParentFlowViewModel())
}
