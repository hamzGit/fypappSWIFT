import SwiftUI
import Combine

struct CharacterView: View {

    enum Scene {
        case brushingTeeth
        case takingBreak
        case moodHappy
        case moodNeutral
        case moodSad
    }

    var scene: Scene

    @State private var currentFrame: Int = 1
    @State private var direction: Int = 1

    var body: some View {
        Group {
            if scene == .brushingTeeth {
                Image("brush_frame_\(currentFrame)")
                    .resizable()
                    .scaledToFit()
            } else if scene == .takingBreak {
                Image("character_break")
                    .resizable()
                    .scaledToFit()
            } else if scene == .moodHappy {
                Image("mood_happy")
                    .resizable()
                    .scaledToFit()
            } else if scene == .moodNeutral {
                Image("mood_neutral")
                    .resizable()
                    .scaledToFit()
            } else {
                Image("mood_sad")
                    .resizable()
                    .scaledToFit()
            }
        }
        .onReceive(
            Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()
        ) { _ in
            if scene == .brushingTeeth {
                advanceFrame()
            }
        }
    }

    private func advanceFrame() {
        let next = currentFrame + direction
        if next > 3 {
            direction = -1
            currentFrame = 2
        } else if next < 1 {
            direction = 1
            currentFrame = 2
        } else {
            currentFrame = next
        }
    }
}
