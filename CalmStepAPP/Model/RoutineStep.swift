//
//  RoutineStep.swift
//  CalmSteps
//
//  a single task inside a routine. e.g. "Brush Teeth"
//

import Foundation
import SwiftData

@Model
final class RoutineStep {
    
    @Attribute(.unique) var id: UUID
    var title: String
    var orderIndex: Int       // controls the order of steps in the list
    
    // optional - not every step needs all of these
    var duration: Int?        // in seconds
    var iconName: String?
    var photoData: Data?      // a photo the parent picked from their library
    var voiceText: String?    // text the app reads out loud during the step
    
    init(title: String,
         orderIndex: Int,
         duration: Int? = nil,
         iconName: String? = nil,
         photoData: Data? = nil,
         voiceText: String? = nil) {
        self.id = UUID()
        self.title = title
        self.orderIndex = orderIndex
        self.duration = duration
        self.iconName = iconName
        self.photoData = photoData
        self.voiceText = voiceText
    }
}
