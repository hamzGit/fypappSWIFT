//
//  AppViewModel.swift
//  CalmSteps
//
//  top-level coordinator. splits the app into three worlds:
//  onboarding hild and parent only one shows at a time.
//

import Foundation
import SwiftUI
import Combine

final class AppViewModel: ObservableObject {

    enum World {
        case onboarding
        case child
        case parent
    }
    
    @Published var currentWorld: World = .onboarding

    func finishOnboarding() {
        currentWorld = .child
    }
    
    func openParentMode() {
        currentWorld = .parent
    }

    func returnToChild() {
        currentWorld = .child
    }
}
