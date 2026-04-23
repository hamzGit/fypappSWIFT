//
//  RoutineRun.swift
//  CalmSteps
//
//  one row saved every time the child finishes a whole routine
//  insights counts these for the "routines completed" number
//

import Foundation
import SwiftData

@Model
final class RoutineRun {
    
    @Attribute(.unique) var id: UUID
    var routineType: String       //"morning" or "evening"
    var completedAt: Date
    
    init(routineType: String, completedAt: Date = .now) {
        self.id = UUID()
        self.routineType = routineType
        self.completedAt = completedAt
    }
}
