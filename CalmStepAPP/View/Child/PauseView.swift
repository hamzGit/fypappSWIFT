//
//  PauseView.swift
//  CalmSteps
//
//  Created by Hamza on 01/03/2026.
//

import SwiftUI
import SwiftData

struct PauseView: View {
    
    @ObservedObject var childVM: ChildFlowViewModel
    @Query private var settingsArray: [AppSettings]
    
    //only one settings record ever, just grab it
    private var settings: AppSettings? {
        return settingsArray.first
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            // break image fills everything
            if settings?.showCharacter == true {
                CharacterView(scene: .takingBreak)
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            
            // overlay content on top
            VStack(spacing: 22) {
                
                Spacer()
                
                Text("ROUTINE PAUSED")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.secondary)
                
                Text("Take a breath")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Button {
                    childVM.resumeRoutine()
                } label: {
                    Image(systemName: "play.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(color: .blue.opacity(0.3), radius: 10, y: 4)
                }
                
                Text("TAP TO RESUME")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .tracking(1.0)
                
                Spacer()
            }
        }
    }
}

#Preview {
    PauseView(childVM: ChildFlowViewModel())
}
