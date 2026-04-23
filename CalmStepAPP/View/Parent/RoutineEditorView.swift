//
//  RoutineEditorView.swift
//  CalmSteps
//
//  edit a routine and its steps move them around or tap to go deeper
//

import SwiftUI
import SwiftData

struct RoutineEditorView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Bindable var routine: Routine
    
    @StateObject private var editorVM = RoutineEditorViewModel()
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        headerRow
                        if sortedSteps.isEmpty == true {
                            emptyState
                        } else {
                            stepsList
                        }
                    }
                    .padding()
                }
                addStepBar
            }
        }
        .navigationTitle("Edit Routine")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
    
    //just done plain bubble sort
    private var sortedSteps: [RoutineStep] {
        var result = routine.steps
        for i in 0..<result.count {
            for j in i+1..<result.count {
                if result[j].orderIndex < result[i].orderIndex {
                    let temp = result[i]
                    result[i] = result[j]
                    result[j] = temp
                }
            }
        }
        return result
    }
    
    private var headerRow: some View {
        HStack {
            Text(routine.title)
                .font(.system(size: 26, weight: .bold))
            Spacer()
            Text("\(sortedSteps.count) Steps")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.12))
                .clipShape(Capsule())
        }
        .padding(.horizontal, 4)
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 40))
                .foregroundStyle(Color.blue.opacity(0.7))
            Text("No steps yet")
                .font(.headline)
            Text("Tap the button below to add your first step")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var stepsList: some View {
        VStack(spacing: 12) {
            ForEach(0..<sortedSteps.count, id: \.self) { index in
                let step = sortedSteps[index]
                stepCard(step: step, number: index + 1)
            }
        }
    }
    
    private func stepCard(step: RoutineStep, number: Int) -> some View {
        VStack(spacing: 0) {
            
            // tap the row to open the edit screen for this step
            NavigationLink(destination: EditStepView(step: step)) {
                HStack(spacing: 14) {
                    stepIcon(step: step)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                        Text(durationText(step: step))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .buttonStyle(.plain)
            
            Divider().padding(.leading, 70)
            
            // move buttons swap the orderIndex with the step above or below
            HStack {
                Button {
                    editorVM.moveStepUp(step, in: routine, context: context)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 12))
                        Text("Move up")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Button {
                    editorVM.moveStepDown(step, in: routine, context: context)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 12))
                        Text("Move down")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func stepIcon(step: RoutineStep) -> some View {
        Group {
            if let data = step.photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.blue.opacity(0.85))
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: step.iconName ?? "star.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.white)
                    }
            }
        }
    }
    
    //pinned to the bottom outside the scrollview so its always visible
    private var addStepBar: some View {
        VStack(spacing: 0) {
            Divider()
            NavigationLink(destination: AddStepView(routine: routine, editorVM: editorVM)) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add Routine Step")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }
            .buttonStyle(.plain)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private func durationText(step: RoutineStep) -> String {
        let total = step.duration ?? 0
        let mins = total / 60
        let secs = total % 60
        if mins > 0 && secs > 0 {
            return "\(mins)m \(secs)s"
        } else if mins > 0 {
            if mins == 1 {
                return "1 minute"
            } else {
                return "\(mins) minutes"
            }
        } else {
            if secs == 1 {
                return "1 second"
            } else {
                return "\(secs) seconds"
            }
        }
    }
}
