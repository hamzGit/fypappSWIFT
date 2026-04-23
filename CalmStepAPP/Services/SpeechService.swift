//
//  SpeechService.swift
//  CalmSteps
//
//  text-to-speech helper. parent types an instruction, app reads it out.
//  using TTS instead of voice recording because it works on simulator
//  and parents can edit the text anytime without re-recording.
//

import Foundation
import AVFoundation
import Combine

final class SpeechService: ObservableObject {
    
    private let synthesizer = AVSpeechSynthesizer()
    
    @Published var isSpeaking = false
    
    func speak(_ text: String) {
        // stop anything currently playing so two previews don't overlap
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.45      // slightly slower than default for young kids
        utterance.volume = 1.0
        
        synthesizer.speak(utterance)
        isSpeaking = true
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }
}
