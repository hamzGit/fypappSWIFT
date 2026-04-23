//
//  RoutineEditorViewModel.swift
//  CalmSteps
//
//  action helper for the routine editor.
//

import Foundation
import SwiftData
import Combine

final class RoutineEditorViewModel: ObservableObject {
    

    
    func addStep(to routine: Routine,
                 title: String,
                 minutes: Int,
                 seconds: Int,
                 iconName: String,
                 context: ModelContext) {
        
        // turn the minutes and seconds into total seconds
        let totalSeconds = (minutes * 60) + seconds
        
        let newStep = RoutineStep(
            title: title,
            orderIndex: routine.steps.count,
            duration: totalSeconds,
            iconName: iconName
        )
        
        
        routine.steps.append(newStep)
        context.insert(newStep)
        try? context.save()
    }
    
    
    
    func deleteStep(_ step: RoutineStep, context: ModelContext) {
        context.delete(step)
        try? context.save()
    }
    
    
    
    func moveStepUp(_ step: RoutineStep,
                    in routine: Routine,
                    context: ModelContext) {
        
        // sort the current steps by their order so we know their positions
        var sorted = routine.steps
        for i in 0..<sorted.count {
            for j in i+1..<sorted.count {
                if sorted[j].orderIndex < sorted[i].orderIndex {
                    let temp = sorted[i]
                    sorted[i] = sorted[j]
                    sorted[j] = temp
                }
            }
        }
        
        
        var position = -1
        for i in 0..<sorted.count {
            if sorted[i].id == step.id {
                position = i
                break
            }
        }
        
        
        if position <= 0 {
            return
        }
        
        
        let stepAbove = sorted[position - 1]
        let temp = step.orderIndex
        step.orderIndex = stepAbove.orderIndex
        stepAbove.orderIndex = temp
        
        try? context.save()
    }
    
    
    
    func moveStepDown(_ step: RoutineStep,
                      in routine: Routine,
                      context: ModelContext) {
        
        // sort the current steps by their order so we know their positions
        var sorted = routine.steps
        for i in 0..<sorted.count {
            for j in i+1..<sorted.count {
                if sorted[j].orderIndex < sorted[i].orderIndex {
                    let temp = sorted[i]
                    sorted[i] = sorted[j]
                    sorted[j] = temp
                }
            }
        }
        
        
        var position = -1
        for i in 0..<sorted.count {
            if sorted[i].id == step.id {
                position = i
                break
            }
        }
        
        // if its already at the bottom or not found do nothing
        if position == -1 || position >= sorted.count - 1 {
            return
        }
        
        // swap the orderIndex of this step with the one below it
        let stepBelow = sorted[position + 1]
        let temp = step.orderIndex
        step.orderIndex = stepBelow.orderIndex
        stepBelow.orderIndex = temp
        
        try? context.save()
    }
}
