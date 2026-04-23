//
//  CreateAccountView.swift
//  CalmSteps
//
//  Created by Hamza on 14/03/2026.
//

import SwiftUI

struct CreateAccountView: View {
    
    @ObservedObject var onboardingVM: OnboardingViewModel
    @ObservedObject var authService: AuthService
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Spacer().frame(height: 60)
                
                Text("Create Account")
                    .font(.system(size: 28, weight: .bold))
                
                TextField("Email address", text: $email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 24)
                
                SecureField("Password (at least 6 characters)", text: $password)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 24)
                
                SecureField("Confirm password", text: $confirmPassword)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 24)
                
                //either local validation error OR firebase error, whichever happened
                if localError != nil {
                    Text(localError!)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 24)
                } else if authService.errorMessage != nil {
                    Text(authService.errorMessage!)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 24)
                }
                
                Button {
                    attemptSignUp()
                } label: {
                    Text(buttonLabel)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 24)
                
                Button {
                    authService.errorMessage = nil
                    onboardingVM.currentPage = .accountSetup
                } label: {
                    Text("Back to account setup")
                        .font(.footnote)
                        .foregroundStyle(.blue)
                }
                
                Spacer()
            }
        }
        .onChange(of: authService.isLoggedIn) { _, loggedIn in
            if loggedIn == true {
                onboardingVM.startFeatureWalkthrough()
            }
        }
    }
    
    //returns nil if all fields are empty or all valid, returns text if passwords dont match
    private var localError: String? {
        if email.isEmpty == true {
            return nil
        }
        if password.isEmpty == true {
            return nil
        }
        if confirmPassword.isEmpty == true {
            return nil
        }
        if password != confirmPassword {
            return "Passwords dont match."
        }
        return nil
    }
    
    private var buttonLabel: String {
        if authService.isLoading == true {
            return "Creating..."
        } else {
            return "Create Account"
        }
    }
    
    private func attemptSignUp() {
        authService.errorMessage = nil
        
        if password != confirmPassword {
            return
        }
        
        authService.signUp(email: email, password: password)
    }
}

#Preview {
    CreateAccountView(onboardingVM: OnboardingViewModel(), authService: AuthService())
}
