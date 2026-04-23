//
//  LoginView.swift
//  CalmSteps
//
//  Created by Hamza on 14/03/2026.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var onboardingVM: OnboardingViewModel
    @ObservedObject var authService: AuthService
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Spacer().frame(height: 60)
                
                Text("Log In")
                    .font(.system(size: 28, weight: .bold))
                
                TextField("Email address", text: $email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 24)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 24)
                
                if authService.errorMessage != nil {
                    Text(authService.errorMessage!)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 24)
                }
                
                Button {
                    authService.signIn(email: email, password: password)
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
    
    private var buttonLabel: String {
        return authService.isLoading ? "Logging in..." : "Log In"
    }
}

#Preview {
    LoginView(onboardingVM: OnboardingViewModel(), authService: AuthService())
}
