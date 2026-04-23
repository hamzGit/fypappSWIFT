//
//  DefaultDataLoader.swift
//  CalmSteps
//
//  Created by Hamza on 08/02/2026.
//

import Foundation
import SwiftData

enum DefaultLoader {
    
    static func loadIfNeeded(context: ModelContext) {
        loadDefaultSettings(context: context)
        loadDefaultRoutines(context: context)
        try? context.save()
    }
    
    private static func loadDefaultSettings(context: ModelContext) {
        let descriptor = FetchDescriptor<AppSettings>()
        let existing = (try? context.fetch(descriptor)) ?? []
        
        if existing.isEmpty == false {
            return
        }
        
        context.insert(AppSettings())
    }
    
    private static func loadDefaultRoutines(context: ModelContext) {
        let descriptor = FetchDescriptor<Routine>()
        let existing = (try? context.fetch(descriptor)) ?? []
        
        if existing.isEmpty == false {
            return
        }
        
        //durations are in seconds not minutes
        let morning = Routine(
            title: "Morning Routine",
            type: .morning,
            iconName: "sun.max.fill",
            steps: [
                RoutineStep(title: "Brush Teeth",  orderIndex: 0, duration: 120, iconName: "mouth.fill"),
                RoutineStep(title: "Rinse Mouth",  orderIndex: 1, duration: 15,  iconName: "drop.fill"),
                RoutineStep(title: "Wash Face",    orderIndex: 2, duration: 30,  iconName: "hands.sparkles.fill"),
                RoutineStep(title: "Get Dressed",  orderIndex: 3, duration: 60,  iconName: "tshirt.fill")
            ]
        )
        
        let evening = Routine(
            title: "Evening Routine",
            type: .evening,
            iconName: "moon.stars.fill",
            steps: [
                RoutineStep(title: "Put On Pajamas",     orderIndex: 0, duration: 60,  iconName: "tshirt.fill"),
                RoutineStep(title: "Brush Teeth",        orderIndex: 1, duration: 120, iconName: "mouth.fill"),
                RoutineStep(title: "Rinse Mouth",        orderIndex: 2, duration: 15,  iconName: "drop.fill"),
                RoutineStep(title: "Take A Deep Breath", orderIndex: 3, duration: 20,  iconName: "wind")
            ]
        )
        
        context.insert(morning)
        context.insert(evening)
    }
}
