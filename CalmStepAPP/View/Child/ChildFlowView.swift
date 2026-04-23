//
//  ChildFlowView.swift
//  CalmSteps
//
//  Created by Hamza on 24/02/2026.
//

import SwiftUI

struct ChildFlowView: View {
    
    var isPreview: Bool = false
    
    @StateObject private var childVM = ChildFlowViewModel()
    @StateObject private var speechService = SpeechService()
    
    var body: some View {
        Group {
            switch childVM.currentScreen {
            case .home:         ChildHomeView(childVM: childVM)
            case .readyPreview: ReadyPreviewView(childVM: childVM)
            case .step:         StepView(childVM: childVM)
            case .transition:   TransitionView(childVM: childVM)
            case .paused:       PauseView(childVM: childVM)
            case .moodCheck:    MoodCheckView(childVM: childVM)
            case .reward:       RewardView(childVM: childVM)
            }
        }
            .onAppear {
                childVM.isPreview = isPreview
            }
            .onChange(of: childVM.currentStepIndex) { _, _ in
                speakCurrentStep()
            }
            .onChange(of: childVM.currentScreen) { _, newScreen in
                if newScreen == .step && childVM.isResumingFromBreak == false {
                    speakCurrentStep()
                }
            }
        }
    
    private func speakCurrentStep() {
        let step = childVM.currentStep
        if step == nil { return }
        let text = step!.voiceText
        if text == nil { return }
        if text!.isEmpty == true { return }
        speechService.speak(text!)
    }
}
