//
//  SegmentedProgressRing.swift
//  CalmSteps
//
//  divides a circle into segments with gaps and fills them as progress increases.
//  used external resources to understand how trim works on a SwiftUI circle. and asked chatgpt to explain to me what is happening and how to tackle it works but not perfect
//

import SwiftUI

struct SegmentedProgressRing: View {
    
    let progress: Double
    let segmentCount: Int
    let lineWidth: CGFloat
    let size: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0..<segmentCount, id: \.self) { i in
                let start = segmentStart(i)
                let end = segmentEnd(i)
                let fill = segmentFill(i)
                
                Circle()
                    .trim(from: start, to: end)
                    .stroke(
                        Color.gray.opacity(0.18),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: size, height: size)
                
                if fill > 0 {
                    Circle()
                        .trim(from: start, to: start + ((end - start) * fill))
                        .stroke(
                            Color.blue.opacity(0.75),
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: size, height: size)
                }
            }
        }
        .animation(.linear(duration: 1.0), value: progress)
    }
    
    // works out how full this segment should be based on overall progress
    // e.g. 5 segments at 60% - segments 0 1 2 are full, segment 3 is partial
    private func segmentFill(_ i: Int) -> CGFloat {
        let clamped = min(max(progress, 0), 1)
        let total = clamped * Double(segmentCount)
        let fill = total - Double(i)
        return CGFloat(min(max(fill, 0), 1))
    }
    
    private func segmentStart(_ i: Int) -> CGFloat {
        let size = 1.0 / CGFloat(segmentCount)
        let gap: CGFloat = 0.018
        return CGFloat(i) * size + gap
    }
    
    private func segmentEnd(_ i: Int) -> CGFloat {
        let size = 1.0 / CGFloat(segmentCount)
        let gap: CGFloat = 0.018
        return CGFloat(i + 1) * size - gap
    }
}
