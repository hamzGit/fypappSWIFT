//
//  ChildHomeView.swift
//  CalmSteps
//
//  Created by Hamza on 27/02/2026.
//

import SwiftUI
import SwiftData

struct ChildHomeView: View {
    
    @ObservedObject var childVM: ChildFlowViewModel
    @EnvironmentObject private var appVM: AppViewModel
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
                    Spacer()
                    Button {
                        appVM.openParentMode()
                    } label: {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.blue)
                            .padding(12)
                            .background(Color.blue.opacity(0.12))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 10)
                
                Spacer()
                
                Circle()
                    .fill(greetingColor.opacity(0.20))
                    .frame(width: 150, height: 150)
                    .overlay {
                        Image(systemName: greetingIcon)
                            .font(.system(size: 50))
                            .foregroundStyle(greetingColor)
                    }
                
                Text(greetingText)
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("Let's start your day together")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                PrimaryButton(title: "Start") {
                    if settings != nil {
                        childVM.startRoutine(context: context, settings: settings!)
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    private var isMorning: Bool {
        if settings == nil { return true }
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= settings!.morningStartHour && hour < settings!.eveningStartHour
    }
    
    private var greetingText: String {
        return isMorning ? "Good Morning" : "Good Evening"
    }
    
    private var greetingIcon: String {
        return isMorning ? "sun.max.fill" : "moon.stars.fill"
    }
    
    private var greetingColor: Color {
        return isMorning ? .yellow : .indigo
    }
}

#Preview {
    ChildHomeView(childVM: ChildFlowViewModel())
        .environmentObject(AppViewModel())
}
