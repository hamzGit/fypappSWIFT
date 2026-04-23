//
//  SettingsView.swift
//  CalmSteps
//
//  parent toggle panel. every control reads and writes AppSettings directly.
//  no Save button - changes persist instantly through SwiftData bindings.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    
    @ObservedObject var parentVM: ParentFlowViewModel
    @Environment(\.modelContext) private var context
    @Query private var settingsArray: [AppSettings]
    @EnvironmentObject private var authService: AuthService
    // shortcut to the single settings record (there's only ever one)
    private var settings: AppSettings? {
        return settingsArray.first
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                // if we have settings, show the sections. otherwise show a spinner.
                if settings != nil {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 18) {
                            headerCard
                            securityCard(settings: settings!)
                            childDisplayCard(settings: settings!)
                            timingCard(settings: settings!)
                            accountCard
                        }
                        .padding()
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Sensory Settings")
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
    
    // ---- the header card at the top ----
    
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Parent Settings")
                .font(.system(size: 18, weight: .bold))
            Text("Adjust how the app looks and behaves")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.blue.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    // ---- SECURITY card ----
    // auto-lock minutes picker + face id toggle
    
    private func securityCard(settings: AppSettings) -> some View {
        settingsCard(title: "SECURITY") {
            VStack(spacing: 0) {
                
                // auto-lock minutes picker
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.orange)
                        .frame(width: 28)
                    Text("Auto-lock Parent Mode")
                    Spacer()
                    
                    // custom binding directly to the autoLockMinutes property
                    Picker("", selection: Binding(
                        get: { settings.autoLockMinutes },
                        set: { newValue in
                            settings.autoLockMinutes = newValue
                            try? context.save()
                        }
                    )) {
                        Text("1 min").tag(1)
                        Text("2 min").tag(2)
                        Text("5 min").tag(5)
                    }
                    .pickerStyle(.menu)
                }
                .padding()
                
                Divider().padding(.leading, 52)
                
                // face id toggle
                faceIDRow(settings: settings)
            }
        }
    }
    
    // face ID toggle row (split out because it has its own binding)
    private func faceIDRow(settings: AppSettings) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "faceid")
                .foregroundStyle(.green)
                .frame(width: 28)
            Text("Face ID / Touch ID")
            Spacer()
            Toggle("", isOn: Binding(
                get: { settings.useFaceID },
                set: { newValue in
                    settings.useFaceID = newValue
                    try? context.save()
                }
            ))
            .labelsHidden()
        }
        .padding()
    }
    
    // ---- CHILD DISPLAY card ----
    // five toggles - each one has its own inline binding.
    
    private func childDisplayCard(settings: AppSettings) -> some View {
        settingsCard(title: "CHILD DISPLAY") {
            VStack(spacing: 0) {
                
                // show timer toggle
                HStack(spacing: 12) {
                    Image(systemName: "timer")
                        .foregroundStyle(.blue)
                        .frame(width: 28)
                    Text("Show timer")
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { settings.showTimer },
                        set: { newValue in
                            settings.showTimer = newValue
                            try? context.save()
                        }
                    ))
                    .labelsHidden()
                }
                .padding()
                
                Divider().padding(.leading, 52)
                
                // show next step toggle
                HStack(spacing: 12) {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundStyle(.purple)
                        .frame(width: 28)
                    Text("Show next step")
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { settings.showNextStep },
                        set: { newValue in
                            settings.showNextStep = newValue
                            try? context.save()
                        }
                    ))
                    .labelsHidden()
                }
                .padding()
                
                Divider().padding(.leading, 52)
                
                // use photos toggle
                HStack(spacing: 12) {
                    Image(systemName: "photo.fill")
                        .foregroundStyle(.green)
                        .frame(width: 28)
                    Text("Use photos")
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { settings.usePhotos },
                        set: { newValue in
                            settings.usePhotos = newValue
                            try? context.save()
                        }
                    ))
                    .labelsHidden()
                }
                .padding()
                
                Divider().padding(.leading, 52)
                
                // show character toggle
                HStack(spacing: 12) {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.orange)
                        .frame(width: 28)
                    Text("Show character")
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { settings.showCharacter },
                        set: { newValue in
                            settings.showCharacter = newValue
                            try? context.save()
                        }
                    ))
                    .labelsHidden()
                }
                .padding()
                
                Divider().padding(.leading, 52)
                
                // dark mode toggle (parent screens only)
                HStack(spacing: 12) {
                    Image(systemName: "moon.fill")
                        .foregroundStyle(.indigo)
                        .frame(width: 28)
                    Text("Dark mode (parent screens)")
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { settings.darkMode },
                        set: { newValue in
                            settings.darkMode = newValue
                            try? context.save()
                        }
                    ))
                    .labelsHidden()
                }
                .padding()
            }
        }
    }
    
    // ---- ROUTINE TIMING card ----
    // morning + evening start hour pickers.
    
    private func timingCard(settings: AppSettings) -> some View {
        settingsCard(title: "ROUTINE TIMING") {
            VStack(spacing: 0) {
                
                // morning starts picker
                HStack {
                    Image(systemName: "sun.max.fill")
                        .foregroundStyle(.yellow)
                        .frame(width: 28)
                    Text("Morning starts")
                    Spacer()
                    Picker("", selection: Binding(
                        get: { settings.morningStartHour },
                        set: { newValue in
                            settings.morningStartHour = newValue
                            try? context.save()
                        }
                    )) {
                        ForEach(0..<24, id: \.self) { h in
                            Text("\(h):00").tag(h)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding()
                
                Divider().padding(.leading, 52)
                
                // evening starts picker
                HStack {
                    Image(systemName: "moon.stars.fill")
                        .foregroundStyle(.purple)
                        .frame(width: 28)
                    Text("Evening starts")
                    Spacer()
                    Picker("", selection: Binding(
                        get: { settings.eveningStartHour },
                        set: { newValue in
                            settings.eveningStartHour = newValue
                            try? context.save()
                        }
                    )) {
                        ForEach(0..<24, id: \.self) { h in
                            Text("\(h):00").tag(h)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding()
            }
        }
    }
    
    // ---- reusable section card wrapper ----
    // takes a title (e.g. "SECURITY") and a block of content to wrap.
    
    private func settingsCard<Content: View>(title: String,
                                             @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.footnote)
                .foregroundStyle(.secondary)
            
            content()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
    // ---- ACCOUNT card (sign out) ----

    private var accountCard: some View {
        settingsCard(title: "ACCOUNT") {
            VStack(spacing: 0) {
                
                //show the current account status
                HStack(spacing: 12) {
                    Image(systemName: authService.isLoggedIn ? "checkmark.circle.fill" : "person.fill.questionmark")
                        .foregroundStyle(authService.isLoggedIn ? .green : .gray)
                        .frame(width: 28)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(authService.isLoggedIn ? "Signed In" : "Local Mode")
                            .font(.system(size: 15, weight: .semibold))
                        Text(authService.isLoggedIn ? "Account active" : "No account connected")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
                
                //only show sign out if theyre currently signed in
                if authService.isLoggedIn == true {
                    
                    Divider().padding(.leading, 52)
                    
                    Button {
                        authService.signOut()
                        if settings != nil {
                            settings!.isGuestMode = true
                            try? context.save()
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundStyle(.red)
                                .frame(width: 28)
                            Text("Sign Out")
                                .foregroundStyle(.red)
                            Spacer()
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
}

#Preview {
    SettingsView(parentVM: ParentFlowViewModel())
}
