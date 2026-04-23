//
//  Routine.swift
//  CalmSteps
//
//  one routine = a named collection of steps like "morning routine"
//  with brush teet wash face get dressed inside it
//

import Foundation
import SwiftData

@Model
final class Routine {
    
    @Attribute(.unique) var id: UUID
    var title: String
    var typeRaw: String           //swiftdata doesnt store enums so we keep the raw string
    var iconName: String
    var isVisible: Bool           //parent can hide a routine without deleting it
    
    //if we delete a routine, delete all its steps too (avoids orphan records)
    @Relationship(deleteRule: .cascade) var steps: [RoutineStep]
    
    //turn the saved string back into the enum when reading
    var type: RoutineType {
        return RoutineType(rawValue: typeRaw) ?? .morning
    }
    
    init(title: String,
         type: RoutineType,
         iconName: String,
         isVisible: Bool = true,
         steps: [RoutineStep] = []) {
        self.id = UUID()
        self.title = title
        self.typeRaw = type.rawValue
        self.iconName = iconName
        self.isVisible = isVisible
        self.steps = steps
    }
}
