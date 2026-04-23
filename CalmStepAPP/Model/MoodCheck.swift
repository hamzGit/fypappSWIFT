//
//  MoodCheck.swift
//  CalmSteps
//
//  saves how the child felt after finishing a routin
//  happy, okay, or sadinsights shows the recent ones with emojis
//

import Foundation
import SwiftData

@Model
final class MoodCheck {
    
    @Attribute(.unique) var id: UUID
    var routineType: String       //"morning" or "evening"
    var mood: String              //"happy", "okay", or "sad"
    var date: Date
    
    init(routineType: String, mood: String, date: Date = .now) {
        self.id = UUID()
        self.routineType = routineType
        self.mood = mood
        self.date = date
    }
}
