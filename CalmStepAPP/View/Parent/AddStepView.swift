//
//  AddStepView.swift
//  CalmSteps
//



import SwiftUI
import SwiftData
import PhotosUI

struct AddStepView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    let routine: Routine
    let editorVM: RoutineEditorViewModel
    
    //blank step is created on appear so photo + voice can attach to a real model immediately
    @State private var step: RoutineStep? = nil
    @State private var title = ""
    @State private var minutes = 1
    @State private var seconds = 0
    @State private var selectedIcon = "star.fill"
    
    @StateObject private var speechService = SpeechService()
    @State private var selectedPhoto: PhotosPickerItem? = nil
    
    private let icons = [
        "star.fill", "mouth.fill", "drop.fill", "hands.sparkles.fill",
        "tshirt.fill", "wind", "moon.fill", "fork.knife"
    ]
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    nameSection
                    durationSection
                    iconSection
                    photoSection
                    audioSection
                }
                .padding()
            }
        }
        .navigationTitle("Add Step")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveStep()
                }
                .disabled(title.isEmpty)
            }
        }
        .onAppear {
            createDraftStep()
        }
        .onDisappear {
            discardIfUnsaved()
        }
        .onChange(of: selectedPhoto) { _, newPhoto in
            loadPhoto(newPhoto)
        }
    }
    
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Step name")
            
            TextField("e.g. Brush Teeth", text: $title)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
    
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Duration")
            
            HStack {
                Picker("minutes", selection: $minutes) {
                    ForEach(0..<60, id: \.self) { m in
                        Text("\(m) min").tag(m)
                    }
                }
                .pickerStyle(.wheel)
                
                Picker("seconds", selection: $seconds) {
                    ForEach(0..<60, id: \.self) { s in
                        Text("\(s) sec").tag(s)
                    }
                }
                .pickerStyle(.wheel)
            }
            .frame(height: 120)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
    
    //2 rows of 4 icons placed by hand same thing as the pin keypad
    private var iconSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Icon")
            
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    iconButton(icon: icons[0])
                    iconButton(icon: icons[1])
                    iconButton(icon: icons[2])
                    iconButton(icon: icons[3])
                }
                HStack(spacing: 10) {
                    iconButton(icon: icons[4])
                    iconButton(icon: icons[5])
                    iconButton(icon: icons[6])
                    iconButton(icon: icons[7])
                }
            }
        }
    }
    
    private func iconButton(icon: String) -> some View {
        
        var backgroundColor = Color(.secondarySystemGroupedBackground)
        if selectedIcon == icon {
            backgroundColor = Color.blue.opacity(0.20)
        }
        
        return Button {
            selectedIcon = icon
        } label: {
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .frame(height: 54)
                .frame(maxWidth: .infinity)
                .overlay {
                    Image(systemName: icon)
                        .foregroundStyle(.blue)
                }
        }
        .buttonStyle(.plain)
    }
    
    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Photo support")
            
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                rowButton(
                    icon: "photo.on.rectangle",
                    title: "Choose from library",
                    subtitle: "Use a familiar image to help your child"
                )
            }
            .buttonStyle(.plain)
            
            if step?.photoData != nil {
                Button {
                    removePhoto()
                } label: {
                    rowButton(
                        icon: "trash",
                        title: "Remove photo",
                        subtitle: "Go back to using the icon"
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var audioSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Audio guidance")
            
            Text("Type a short instruction. The app will read it aloud during the step.")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            TextField("e.g. Remember to rinse three times", text: voiceTextBinding)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            
            if shouldShowPreviewButton == true {
                Button {
                    togglePreview()
                } label: {
                    rowButton(
                        icon: previewIcon,
                        title: previewTitle,
                        subtitle: "Hear how it will sound to the child"
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.footnote)
            .foregroundStyle(.secondary)
    }
    
    private func rowButton(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.12))
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: icon)
                        .foregroundStyle(.blue)
                }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    // just a custome binding that is basicaly the translator readin optional and returns string or empty if nil
    private var voiceTextBinding: Binding<String> {
        Binding(
            get: {
                if step == nil {
                    return ""
                }
                if step!.voiceText == nil {
                    return ""
                }
                return step!.voiceText!
            },
            set: { newValue in
                if step == nil {
                    return
                }
                if newValue.isEmpty == true {
                    step!.voiceText = nil
                } else {
                    step!.voiceText = newValue
                }
                try? context.save()
            }
        )
    }
    
    private var shouldShowPreviewButton: Bool {
        if step == nil {
            return false
        }
        if step!.voiceText == nil {
            return false
        }
        if step!.voiceText!.isEmpty == true {
            return false
        }
        return true
    }
    
    private var previewIcon: String {
        if speechService.isSpeaking == true {
            return "stop.circle.fill"
        } else {
            return "play.circle.fill"
        }
    }
    
    private var previewTitle: String {
        if speechService.isSpeaking == true {
            return "Tap to stop"
        } else {
            return "Preview voice instruction"
        }
    }
    
    private func togglePreview() {
        if speechService.isSpeaking == true {
            speechService.stop()
        } else {
            if step != nil && step!.voiceText != nil {
                speechService.speak(step!.voiceText!)
            }
        }
    }
    
    //ai helped me with this Task bit- something about photos being big so it has to load on a background thread
    private func loadPhoto(_ item: PhotosPickerItem?) {
        if item == nil {
            return
        }
        if step == nil {
            return
        }
        
        Task {
            let loadedData = try? await item!.loadTransferable(type: Data.self)
            if loadedData != nil {
                step!.photoData = loadedData
                try? context.save()
            }
        }
    }
    
    private func removePhoto() {
        if step == nil {
            return
        }
        step!.photoData = nil
        try? context.save()
    }
    
    //makes a blank step in swiftdata so the photo and the voice sections have something to attach to
    //if the parent cancels we delete it in ondisappeear
    private func createDraftStep() {
        if step != nil {
            return
        }
        
        let blank = RoutineStep(
            title: "",
            orderIndex: routine.steps.count
        )
        context.insert(blank)
        routine.steps.append(blank)
        try? context.save()
        
        step = blank
    }
    
    private func saveStep() { // when perssing save
        if step == nil {
            return
        }
        
        step!.title = title
        step!.duration = (minutes * 60) + seconds
        step!.iconName = selectedIcon
        try? context.save()
        
        dismiss()
    }
    
    //if the parent backed out without typing a title just tttthrow away the draft step
    private func discardIfUnsaved() {
        if step == nil {
            return
        }
        if step!.title.isEmpty == true {
            context.delete(step!)
            try? context.save()
        }
    }
}
