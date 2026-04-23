//
//  HEYITSMELUFFYApp.swift
//  CalmSteps
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct CalmStepAPPApp: App {
    
    //shared services at the app level so every view sees the same instance
    @StateObject private var authService = AuthService()
    @StateObject private var appVM = AppViewModel()
    
    //configure firebase when the app launches
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appVM)
                .environmentObject(authService)
        }
        .modelContainer(for: [
            AppSettings.self,
            Routine.self,
            RoutineStep.self,
            BreakEvent.self,
            RoutineRun.self,
            MoodCheck.self
        ])
    }
}
