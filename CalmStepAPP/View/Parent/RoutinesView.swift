//
//  RoutinesView.swift
//  CalmSteps
//
//  list of all routines parent taps one to edit or hides it from the child
//

import SwiftUI
import SwiftData

struct RoutinesView: View {
    
    @ObservedObject var parentVM: ParentFlowViewModel
    @Environment(\.modelContext) private var context
    
    // live updating list from swiftdata - updates automatically when routines change
    @Query private var routinesArray: [Routine]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        headerCard
                        ForEach(sortedRoutines, id: \.id) { routine in
                            routineCard(routine)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Routines")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        parentVM.goToDashboard()
                    }
                }
            }
        }
    }
    
    // bubble sort alphabetically because swiftdata doesnt guarantee order
    private var sortedRoutines: [Routine] {
        var result = routinesArray
        for i in 0..<result.count {
            for j in i+1..<result.count {
                if result[j].title < result[i].title {
                    let temp = result[i]
                    result[i] = result[j]
                    result[j] = temp
                }
            }
        }
        return result
    }
    
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Your Routines")
                .font(.system(size: 18, weight: .bold))
            Text("Tap a routine to add or edit steps")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.blue.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private func routineCard(_ routine: Routine) -> some View {
        
        // sun for morning moon for evening
        var iconName = "sun.max.fill"
        var iconColor = Color.yellow
        if routine.type == .evening {
            iconName = "moon.stars.fill"
            iconColor = Color.indigo
        }
        
        let stepCount = routine.steps.count
        var stepText = "\(stepCount) steps"
        if stepCount == 1 {
            stepText = "1 step"
        }
        
        return NavigationLink {
            RoutineEditorView(routine: routine)
        } label: {
            HStack(spacing: 14) {
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: iconName)
                            .font(.system(size: 22))
                            .foregroundStyle(iconColor)
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(routine.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text(stepText)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // eye button hides or shows this routine in child mode
                Button {
                    toggleVisibility(routine)
                } label: {
                    Image(systemName: routine.isVisible ? "eye.fill" : "eye.slash.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(routine.isVisible ? Color.blue : Color.gray)
                        .frame(width: 36, height: 36)
                        .background(Color(.tertiarySystemGroupedBackground))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
    
    private func toggleVisibility(_ routine: Routine) {
        if routine.isVisible == true {
            routine.isVisible = false
        } else {
            routine.isVisible = true
        }
        try? context.save()
    }
}

#Preview {
    RoutinesView(parentVM: ParentFlowViewModel())
}
