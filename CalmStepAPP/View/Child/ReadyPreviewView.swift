//
//  ReadyPreviewView.swift
//  CalmSteps
//
//  Created by Hamza on 03/03/2026.
//

import SwiftUI

struct ReadyPreviewView: View {
    
    @ObservedObject var childVM: ChildFlowViewModel
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                
                Spacer().frame(height: 20)
                
                Circle()
                    .fill(routineColor.opacity(0.20))
                    .frame(width: 130, height: 130)
                    .overlay {
                        Image(systemName: routineIcon)
                            .font(.system(size: 48))
                            .foregroundStyle(routineColor)
                    }
                
                Text("Ready?")
                    .font(.system(size: 30, weight: .bold))
                
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(0..<childVM.sortedSteps.count, id: \.self) { index in
                        timelineRow(index: index)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal, 24)
                
                Spacer()
                
                PrimaryButton(title: "Let's Go!") {
                    childVM.beginSteps()
                }
                .padding(.bottom, 24)
            }
        }
    }
    
    private func timelineRow(index: Int) -> some View {
        let step = childVM.sortedSteps[index]
        let isFirst = index == 0
        
        let circleColor = isFirst ? Color.blue.opacity(0.85) : Color.gray.opacity(0.25)
        let iconColor: Color = isFirst ? .white : .secondary
        let titleColor: Color = isFirst ? .primary : .secondary
        let subtitleText = isFirst ? "Starting now" : "Coming up"
        let iconName = step.iconName ?? "circle.fill"
        
        return HStack(spacing: 14) {
            if let data = step.photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 38, height: 38)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(circleColor)
                    .frame(width: 38, height: 38)
                    .overlay {
                        Image(systemName: iconName)
                            .font(.system(size: 16))
                            .foregroundStyle(iconColor)
                    }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(step.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(titleColor)
                Text(subtitleText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }
    
    private var routineIcon: String {
        return childVM.currentRoutineType == .morning ? "sun.max.fill" : "moon.stars.fill"
    }
    
    private var routineColor: Color {
        return childVM.currentRoutineType == .morning ? .yellow : .indigo
    }
}

#Preview {
    ReadyPreviewView(childVM: ChildFlowViewModel())
}
