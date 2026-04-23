//
//  TransitionView.swift
//  CalmSteps
//
//  Created by Hamza on 06/03/2026.
//

import SwiftUI

struct TransitionView: View {
    
    @ObservedObject var childVM: ChildFlowViewModel
    
    //goes from 0 to 1 over 3 seconds when this screen appears, drives the bar fill
    @State private var barProgress: Double = 0
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 22) {
                
                Spacer()
                
                //big preview car
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.blue.opacity(0.10))
                    .frame(width: 240, height: 240)
                    .overlay {
                        VStack(spacing: 12) {
                            previewVisual
                            
                            Text(nextTitle)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(.primary)
                        }
                    }
                
                Text("Transitioning")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary)
                
                animatedBar
                
                Text("Take a deep breath…")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                Spacer()
                PrimaryButton(title: "I'm Ready") {
                    childVM.goToNextStep()
                }
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            startBarAnimation()
        }
        .onDisappear {
            //reset so next time the bar starts empty
            barProgress = 0
        }
    }
    // the animation for the bar fillin
    private var animatedBar: some View {
        
        let totalWidth: CGFloat = 240
        let fillWidth = totalWidth * CGFloat(barProgress)
        
        return Capsule()
            .fill(Color.blue.opacity(0.15))
            .frame(width: totalWidth, height: 10)
            .overlay(alignment: .leading) {
                Capsule()
                    .fill(Color.blue.opacity(0.75))
                    .frame(width: fillWidth, height: 10)
            }
    }
    
    //3 seconds was chosen as a calm pause long enough to breathe not tooo long the child wanders off
    private func startBarAnimation() {
        barProgress = 0
        withAnimation(.linear(duration: 3.0)) {
            barProgress = 1.0
        }
    }
    
    //photo if the parent set on
    private var previewVisual: some View {
        Group {
            if let step = childVM.nextStep,
               let photoData = step.photoData,
               let image = UIImage(data: photoData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Image(systemName: nextIcon)
                    .font(.system(size: 50))
                    .foregroundStyle(.blue.opacity(0.8))
            }
        }
    }

    private var nextIcon: String {
        if childVM.nextStep == nil {
            return "arrow.right.circle.fill"
        }
        if childVM.nextStep!.iconName != nil {
            return childVM.nextStep!.iconName!
        }
        return "arrow.right.circle.fill"
    }
    
    private var nextTitle: String {
        if childVM.nextStep == nil {
            return "Next Step"
        }
        return childVM.nextStep!.title
    }
}

#Preview {
    TransitionView(childVM: ChildFlowViewModel())
}
