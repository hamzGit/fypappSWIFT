//
//  BreakEvent.swift
//  CalmSteps
//
//  one row saved every time the child taps "i need a break" during a step
//  insights uses these to spot which steps cause the most breaks
//

import Foundation
import SwiftData

@Model
final class BreakEvent {
    
    @Attribute(.unique) var id: UUID
    var routineType: String       //"morning" or "evening"
    var stepTitle: String         //readable name for insights
    var stepIndex: Int            //position of the step (0, 1, 2...)
    var date: Date
    
    init(routineType: String,
         stepTitle: String,
         stepIndex: Int,
         date: Date = .now) {      //defaults to right now if not passed
        self.id = UUID()
        self.routineType = routineType
        self.stepTitle = stepTitle
        self.stepIndex = stepIndex
        self.date = date
    }
}
