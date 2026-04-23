//
//  AppSettings.swift
//  CalmSteps
//



import Foundation
import SwiftData

@Model
final class AppSettings {
    
    @Attribute(.unique) var id: UUID
    
    //when morning and evening routines are active (hour 0-23)
    var morningStartHour: Int
    var eveningStartHour: Int
    
    //security
    var hasSetPIN: Bool           //false until parent picks one in onboarding
    var savedPIN: String          //the 4 digits the parent chose
    var autoLockMinutes: Int      //how long before parent mode auto-locks
    var useFaceID: Bool
    
    //appearance (only applies to parent screens)
    var darkMode: Bool
    
    //what the child sees during a routine
    var showTimer: Bool
    var showNextStep: Bool
    var usePhotos: Bool
    var showCharacter: Bool
    
    //so we skip onboarding on future launches
    var hasCompletedOnboarding: Bool
    
    //true if parent picked "continue without an account" during onboarding
    var isGuestMode: Bool
    
    init() {
        self.id = UUID()
        self.morningStartHour = 6
        self.eveningStartHour = 17
        self.hasSetPIN = false
        self.savedPIN = ""
        self.autoLockMinutes = 2
        self.useFaceID = false
        self.darkMode = false
        self.showTimer = true
        self.showNextStep = true
        self.usePhotos = true
        self.showCharacter = true
        self.hasCompletedOnboarding = false
        self.isGuestMode = false
    }
}
