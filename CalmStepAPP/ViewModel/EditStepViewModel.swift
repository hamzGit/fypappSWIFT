//
//  EditStepViewModel.swift
//  CalmSteps
//
//  holds a draft of a step's values while the parent edits them.
//  only writes them back to SwiftData when the parent taps Save.
//  if they tap Cancel, the draft is thrown away and the step is untouched.
//

import Foundation
import SwiftData
import Combine

final class EditStepViewModel: ObservableObject {
    
    // ---- the draft values shown in the edit form ----
    
    @Published var title: String = ""
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    @Published var selectedIcon: String = "star.fill"
    
    // ---- load the step's current values into the form ----
    // called when the edit screen first appears
    func loadStep(_ step: RoutineStep) {
        title = step.title
        
        if step.iconName != nil {
            selectedIcon = step.iconName!
        } else {
            selectedIcon = "star.fill"
        }
        
        // split the total seconds into minutes and seconds
        // so the two wheel pickers show the right values
        var total = 0
        if step.duration != nil {
            total = step.duration!
        }
        
        minutes = total / 60
        seconds = total % 60
    }
    
    // ---- write the draft values back to the step ----
    // called when the parent taps Save
    func saveStep(_ step: RoutineStep, context: ModelContext) {
        step.title = title
        step.iconName = selectedIcon
        step.duration = (minutes * 60) + seconds
        try? context.save()
    }
    
    // ---- delete the step entirely ----
    // called when the parent taps the red Delete button
    func deleteStep(_ step: RoutineStep, context: ModelContext) {
        context.delete(step)
        try? context.save()
    }
    
    // ---- a readable duration string shown in the preview card ----
    // updates automatically as the parent spins the wheels
    // examples: "2 minutes", "1m 30s", "45 seconds"
    var durationPreview: String {
        let total = (minutes * 60) + seconds
        let mins = total / 60
        let secs = total % 60
        
        // both minutes and seconds
        if mins > 0 && secs > 0 {
            return "\(mins)m \(secs)s"
        }
        
        // only minutes
        if mins > 0 {
            if mins == 1 {
                return "1 minute"
            } else {
                return "\(mins) minutes"
            }
        }
        
        // only seconds
        if secs == 1 {
            return "1 second"
        } else {
            return "\(secs) seconds"
        }
    }
}
