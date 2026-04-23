//
//  StepView.swift
//  CalmSteps
//

import SwiftUI
import SwiftData

struct StepView: View {
    
    @ObservedObject var childVM: ChildFlowViewModel
    @Environment(\.modelContext) private var context
    @Query private var settingsArray: [AppSettings]
    
    private var settings: AppSettings? {
        return settingsArray.first
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 18) {
                HStack {
                    Button {
                        childVM.returnHome()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .padding(10)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                Spacer()
                
                ZStack {
                    SegmentedProgressRing(
                        progress: progress,
                        segmentCount: 5,
                        lineWidth: 16,
                        size: 240
                    )
                    
                    if let step = childVM.currentStep,
                       let data = step.photoData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 130, height: 130)
                            .clipShape(Circle())
                    } else if settings?.showCharacter == true,
                              childVM.currentStep?.title.lowercased().contains("brush") == true ||
                              childVM.currentStep?.title.lowercased().contains("teeth") == true {
                        CharacterView(scene: .brushingTeeth)
                            .frame(width: 180, height: 180)
                    } else {
                        Image(systemName: stepIcon)
                            .font(.system(size: 50))
                            .foregroundStyle(.blue)
                    }
                }
                .frame(width: 240, height: 240)
                
                Text(stepTitle)
                    .font(.system(size: 24, weight: .bold))
                
                if settings?.showTimer == true {
                    Text(childVM.timerText)
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button {
                        childVM.takeBreak(context: context)
                    } label: {
                        HStack {
                            Image(systemName: "pause.fill")
                            Text("I Need a Break").fontWeight(.semibold)
                        }
                        .foregroundStyle(.purple)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.purple.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    PrimaryButton(title: "I'm Finished") {
                        childVM.completeCurrentStep(context: context, settings: settings)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
    
    private var progress: Double {
        if childVM.currentStep == nil { return 0 }
        var total = 0
        if childVM.currentStep!.duration != nil {
            total = childVM.currentStep!.duration!
        }
        if total <= 0 { return 0 }
        let elapsed = total - childVM.remainingSeconds
        let ratio = Double(elapsed) / Double(total)
        if ratio < 0 { return 0 }
        if ratio > 1 { return 1 }
        return ratio
    }
    
    private var stepTitle: String {
        return childVM.currentStep?.title ?? "Step"
    }
    
    private var stepIcon: String {
        return childVM.currentStep?.iconName ?? "star.fill"
    }
}

#Preview {
    StepView(childVM: ChildFlowViewModel())
}
