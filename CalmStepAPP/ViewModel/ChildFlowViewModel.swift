//
//  ChildFlowViewModel.swift
//  CalmSteps
//
//  brain for the child experience.
//  loads the right routine, tracks the current step, runs the timer
//  and saves break/completion/mood events to SwiftData.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

final class ChildFlowViewModel: ObservableObject {
    
    enum Screen {
        case home
        case readyPreview
        case step
        case transition
        case paused
        case moodCheck
        case reward
    }
    
    @Published var currentScreen: Screen = .home
    @Published var currentRoutineType: RoutineType = .morning
    @Published var currentSteps: [RoutineStep] = []
    @Published var currentStepIndex: Int = 0
    @Published var remainingSeconds: Int = 0
    
    //set to true when launched from parent preview mode stops real data being saved
    var isPreview: Bool = false
    
    //set to true when resuming from a break so TTS doesnt replay the same step
    var isResumingFromBreak: Bool = false
    
    private var timer: Timer?
    
    // bubble sort so steps always run in the right order
    var sortedSteps: [RoutineStep] {
        var result = currentSteps
        for i in 0..<result.count {
            for j in i+1..<result.count {
                if result[j].orderIndex < result[i].orderIndex {
                    let temp = result[i]
                    result[i] = result[j]
                    result[j] = temp
                }
            }
        }
        return result
    }
    
    var currentStep: RoutineStep? {
        if currentStepIndex < sortedSteps.count {
            return sortedSteps[currentStepIndex]
        }
        return nil
    }
    
    var nextStep: RoutineStep? {
        let nextIndex = currentStepIndex + 1
        if nextIndex < sortedSteps.count {
            return sortedSteps[nextIndex]
        }
        return nil
    }
    
    var totalSteps: Int {
        return sortedSteps.count
    }
    
    // builds "02:15" style timer string with leading zeros
    var timerText: String {
        let mins = remainingSeconds / 60
        let secs = remainingSeconds % 60
        var minsText = "\(mins)"
        if mins < 10 { minsText = "0\(mins)" }
        var secsText = "\(secs)"
        if secs < 10 { secsText = "0\(secs)" }
        return minsText + ":" + secsText
    }
    
    func startRoutine(context: ModelContext, settings: AppSettings) {
        stopTimer()
        currentStepIndex = 0
        currentRoutineType = decideRoutineType(settings: settings)
        
        let descriptor = FetchDescriptor<Routine>()
        let allRoutines = (try? context.fetch(descriptor)) ?? []
        
        // find the first visible routine that matches morning or evening
        var foundRoutine: Routine? = nil
        for routine in allRoutines {
            if routine.type == currentRoutineType && routine.isVisible == true {
                foundRoutine = routine
                break
            }
        }
        
        if foundRoutine == nil {
            currentSteps = []
            currentScreen = .home
            return
        }
        
        currentSteps = foundRoutine!.steps
        currentScreen = .readyPreview
    }
    
    func beginSteps() {
        isResumingFromBreak = false
        currentStepIndex = 0
        currentScreen = .step
        resetTimer()
        startTimer()
    }
    
    func completeCurrentStep(context: ModelContext, settings: AppSettings?) {
        stopTimer()
        let isLastStep = currentStepIndex >= sortedSteps.count - 1
        if isLastStep == true {
            finishRoutine(context: context)
        } else {
            // only show transition screen if parent has it turned on in settings
            if settings?.showNextStep == true {
                currentScreen = .transition
            } else {
                goToNextStep()
            }
        }
    }
    
    func goToNextStep() {
        isResumingFromBreak = false
        currentStepIndex = currentStepIndex + 1
        currentScreen = .step
        resetTimer()
        startTimer()
    }
    
    func takeBreak(context: ModelContext) {
        stopTimer()
        //skip saving if this is a preview session
        if isPreview == false {
            if currentStep != nil {
                let event = BreakEvent(
                    routineType: currentRoutineType.rawValue,
                    stepTitle: currentStep!.title,
                    stepIndex: currentStepIndex
                )
                context.insert(event)
                try? context.save()
            }
        }
        currentScreen = .paused
    }
    
    func resumeRoutine() {
        //flag stops TTS replaying when we come back to the same step
        isResumingFromBreak = true
        currentScreen = .step
        startTimer()
    }
    
    private func finishRoutine(context: ModelContext) {
        //skip saving if this is a preview session
        if isPreview == false {
            let run = RoutineRun(routineType: currentRoutineType.rawValue)
            context.insert(run)
            try? context.save()
        }
        currentScreen = .moodCheck
    }
    
    func recordMood(_ mood: String?, context: ModelContext) {
        //skip saving if this is a preview session
        if isPreview == false {
            if mood != nil {
                let check = MoodCheck(
                    routineType: currentRoutineType.rawValue,
                    mood: mood!
                )
                context.insert(check)
                try? context.save()
            }
        }
        currentScreen = .reward
    }
    
    func returnHome() {
        currentScreen = .home
        currentStepIndex = 0
        remainingSeconds = 0
        stopTimer()
    }
    
    func resetTimer() {
        if currentStep != nil {
            remainingSeconds = currentStep!.duration ?? 0
        } else {
            remainingSeconds = 0
        }
    }
    
    func startTimer() {
        stopTimer()
        if remainingSeconds <= 0 { return }
        
        // [weak self] stops the timer holding onto this viewmodel in memory
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
            } else {
                self.stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func decideRoutineType(settings: AppSettings) -> RoutineType {
        let hour = Calendar.current.component(.hour, from: Date())
        // morning if the hour falls between the two start times the parent set
        if hour >= settings.morningStartHour && hour < settings.eveningStartHour {
            return .morning
        } else {
            return .evening
        }
    }
}
