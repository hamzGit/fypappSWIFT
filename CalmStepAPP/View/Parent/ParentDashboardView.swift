//
//  ParentDashboardView.swift
//  CalmSteps
//

import SwiftUI

struct ParentDashboardView: View {
    
    @ObservedObject var parentVM: ParentFlowViewModel
    
    //closure from ParentFlowView- combines parentVM.lock() + appVM.returnToChild()
    let onLock: () -> Void
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 18) {
                
                topBar
                
                welcomeCard
                
                //the main action rows
                VStack(spacing: 12) {
                    
                    actionRow(
                        icon: "list.bullet.rectangle",
                        title: "Routines",
                        subtitle: "Manage daily schedules and timers",
                        backgroundColor: Color(.secondarySystemGroupedBackground),
                        iconBackgroundColor: Color.blue.opacity(0.15),
                        iconColor: .blue
                    ) {
                        parentVM.goToRoutines()
                    }
                    
                    actionRow(
                        icon: "chart.bar.fill",
                        title: "Insights",
                        subtitle: "View weekly consistency reports",
                        backgroundColor: Color(.secondarySystemGroupedBackground),
                        iconBackgroundColor: Color.blue.opacity(0.15),
                        iconColor: .blue
                    ) {
                        parentVM.goToInsights()
                    }
                    
                    //preview child mode- highlighted in green so it stands out
                    actionRow(
                        icon: "eye.fill",
                        title: "Preview Child Mode",
                        subtitle: "View the sensory-friendly interface",
                        backgroundColor: Color.green.opacity(0.15),
                        iconBackgroundColor: Color.green.opacity(0.25),
                        iconColor: .green
                    ) {
                        parentVM.goToChildPreview()
                    }
                }
                .padding(.horizontal, 18)
                
                Spacer()
                
                privacyFooter
                
                //lock button to leave parent mode
                Button {
                    onLock()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "lock.fill")
                        Text("Lock")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 38)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    //top bar with the settings cog on the left and help on the right
    private var topBar: some View {
        HStack {
            Button {
                parentVM.goToSettings()
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(.primary)
                    .frame(width: 40, height: 40)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Text("Parent Dashboard")
                .font(.system(size: 20, weight: .bold))
            
            Spacer()
            
            Button {
                parentVM.goToHelp()
            } label: {
                Image(systemName: "questionmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                    .frame(width: 40, height: 40)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 10)
    }
    
    private var welcomeCard: some View {
        VStack(spacing: 6) {
            Text("Welcome Back")
                .font(.system(size: 26, weight: .bold))
            Text("Ready to plan a peaceful day?")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 26)
        .background(Color.blue.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 18)
    }
    
    private var privacyFooter: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 10))
                Text("PRIVACY GUARANTEED")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(1.0)
            }
            .foregroundStyle(.secondary)
            
            Text("Your data stays on this device")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
    
    //reusable row with an icon on the left and title + subtitle on the right
    private func actionRow(icon: String,
                           title: String,
                           subtitle: String,
                           backgroundColor: Color,
                           iconBackgroundColor: Color,
                           iconColor: Color,
                           action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(iconBackgroundColor)
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: icon)
                            .font(.system(size: 22))
                            .foregroundStyle(iconColor)
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding(14)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
}

#Preview {
    ParentDashboardView(
        parentVM: ParentFlowViewModel(),
        onLock: {}
    )
}
