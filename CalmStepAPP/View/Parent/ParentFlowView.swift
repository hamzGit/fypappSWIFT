//
//  ParentFlowView.swift
//  CalmSteps
//
//  switcher for the parent world owns the ParentFlowViewModel
//

import SwiftUI
import SwiftData

struct ParentFlowView: View {
    
    @StateObject private var parentVM = ParentFlowViewModel()
    @EnvironmentObject private var appVM: AppViewModel
    @Query private var settingsArray: [AppSettings]
    
    private var settings: AppSettings? {
        return settingsArray.first
    }
    
    var body: some View {
        Group {
            switch parentVM.currentScreen {
                
            case .pin:
                ParentPINView(parentVM: parentVM)
                    .onAppear {
                        // try face id automatically if the parent has it enabled
                        if settings?.useFaceID == true {
                            parentVM.tryFaceID()
                        }
                    }
                
            case .dashboard:
                ParentDashboardView(
                    parentVM: parentVM,
                    onLock: {
                        parentVM.lock()
                        appVM.returnToChild()
                    }
                )
                
            case .routines:
                RoutinesView(parentVM: parentVM)
                
            case .settings:
                SettingsView(parentVM: parentVM)
                
            case .insights:
                InsightsView(parentVM: parentVM)
                
            case .help:
                HelpView(parentVM: parentVM)
                
            case .childPreview:
                // reuses childfloview exactly but with isPreview true so no real data gets saved
                ChildFlowView(isPreview: true)
                    .overlay(alignment: .topLeading) {
                        Button {
                            parentVM.goToDashboard()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.gray)
                                .padding()
                        }
                    }
            }
        }
        // makes the whole area tappable so every interaction resets the auto-lock countdown
        .contentShape(Rectangle())
        .onTapGesture {
            if settings != nil {
                parentVM.resetAutoLock(minutes: settings!.autoLockMinutes)
            }
        }
        .onAppear {
            if settings != nil {
                parentVM.resetAutoLock(minutes: settings!.autoLockMinutes)
            }
        }
        .onDisappear {
            parentVM.stopAutoLock()
        }
        // dark mode scoped to parent screens only not the child world
        .preferredColorScheme(parentColorScheme)
    }
    
    private var parentColorScheme: ColorScheme? {
        if settings == nil {
            return .light
        }
        if settings!.darkMode == true {
            return .dark
        } else {
            return .light
        }
    }
}
