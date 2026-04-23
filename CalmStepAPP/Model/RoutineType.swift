//
//  RoutineType.swift
//  CalmSteps
//
//  just two cases- morning or evening. using an enum so we dont
//  get typos like "mornign" silently breaking the app.
//

import Foundation

enum RoutineType: String, Codable {
    case morning
    case evening
}
