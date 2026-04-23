//
//  ContentView.swift
//  CalmSteps
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @EnvironmentObject private var appVM: AppViewModel
    @EnvironmentObject private var authService: AuthService
    @Environment(\.modelContext) private var context
    @Query private var settingsArray: [AppSettings]
    
    private var settings: AppSettings? {
        return settingsArray.first
    }
    
    var body: some View {
        Group {
            //onboarding not done yet- always show onboarding first
            //(safety disclaimer comes before account choice, as per figma)
            if settings == nil || settings!.hasCompletedOnboarding == false {
                OnboardingFlowView()
            }
            //onboarding done, parent tapped lock- show parent world
            else if appVM.currentWorld == .parent {
                ParentFlowView()
            }
            //otherwise show the child world
            else {
                ChildFlowView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appVM.currentWorld)
        //make sure default routines exist once settings are ready
        .onAppear {
            DefaultLoader.loadIfNeeded(context: context)
        }
    }
}
