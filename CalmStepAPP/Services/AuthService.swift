//
//  AuthService.swift
//  CalmSteps


import Foundation
import FirebaseAuth
import Combine

// i used a video on firebase my teacher has put up on my Mobile Dev Lodule
// before that i used - https://youtu.be/h5uol8le9yA?si=jHvihJdwxJSWCoes

final class AuthService: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    init() {
        //firebase keychain remembers sign-in across app launches
        //so we check if theres already a user before the login screen shows
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        }
    }
    
    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            self.isLoading = false
            
            if error != nil {
                self.errorMessage = error!.localizedDescription
                return
            }
            
            self.isLoggedIn = true
        }
    }
    
    func signUp(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            self.isLoading = false
            
            if error != nil {
                self.errorMessage = error!.localizedDescription
                return
            }
            
            self.isLoggedIn = true
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        isLoggedIn = false
    }
}
