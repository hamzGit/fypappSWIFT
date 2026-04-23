//
//  EditStepView.swift
//  CalmSteps
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditStepView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Bindable var step: RoutineStep
    
    @StateObject private var editStepVM = EditStepViewModel()
    @StateObject private var speechService = SpeechService()
    
    @State private var selectedPhoto: PhotosPickerItem? = nil
    
    //two rows of four icons placed by same approach as AddStepView and the pin keypad
    private let firstRowIcons = ["star.fill", "mouth.fill", "drop.fill", "hands.sparkles.fill"]
    private let secondRowIcons = ["tshirt.fill", "wind", "moon.fill", "fork.knife"]
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    previewCard
                    nameSection
                    durationSection
                    iconSection
                    photoSection
                    audioSection
                    deleteButton
                }
                .padding()
            }
        }
        .navigationTitle("Edit Step")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    editStepVM.saveStep(step, context: context)
                    dismiss()
                }
                .disabled(editStepVM.title.isEmpty)
            }
        }
        .onAppear {
            //load the existing step values into the form
            editStepVM.loadStep(step)
        }
        .onChange(of: selectedPhoto) { _, newPhoto in
            loadPhoto(newPhoto)
        }
    }
    
    private var previewCard: some View {
        
        var displayTitle = editStepVM.title
        if editStepVM.title.isEmpty == true {
            displayTitle = "Step name"
        }
        
        var hasPhoto = false
        if step.photoData != nil {
            hasPhoto = true
        }
        
        var photoImage: UIImage? = nil
        if hasPhoto == true {
            photoImage = UIImage(data: step.photoData!)
        }
        
        return HStack(spacing: 12) {
            
            //photo overrides the icon if the parent picked one
            if photoImage != nil {
                Image(uiImage: photoImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            } else {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 56, height: 56)
                    .overlay {
                        Image(systemName: editStepVM.selectedIcon)
                            .foregroundStyle(.blue)
                    }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(displayTitle)
                    .font(.headline)
                Text(editStepVM.durationPreview)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Step name")
            
            TextField("Enter step name", text: $editStepVM.title)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
    
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Duration")
            
            HStack {
                Picker("minutes", selection: $editStepVM.minutes) {
                    ForEach(0..<60, id: \.self) { m in
                        Text("\(m) min").tag(m)
                    }
                }
                .pickerStyle(.wheel)
                
                Picker("seconds", selection: $editStepVM.seconds) {
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
    
    private var iconSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Icon")
            
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    iconButton(icon: firstRowIcons[0])
                    iconButton(icon: firstRowIcons[1])
                    iconButton(icon: firstRowIcons[2])
                    iconButton(icon: firstRowIcons[3])
                }
                HStack(spacing: 10) {
                    iconButton(icon: secondRowIcons[0])
                    iconButton(icon: secondRowIcons[1])
                    iconButton(icon: secondRowIcons[2])
                    iconButton(icon: secondRowIcons[3])
                }
            }
        }
    }
    
    private func iconButton(icon: String) -> some View {
        
        //highlight the icon if its the selected one
        var backgroundColor = Color(.secondarySystemGroupedBackground)
        if editStepVM.selectedIcon == icon {
            backgroundColor = Color.blue.opacity(0.20)
        }
        
        return Button {
            editStepVM.selectedIcon = icon
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
            
            //only show the remove option if a photo has been picked
            if step.photoData != nil {
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
            
            //custom binding because voicetext is optional but textfieald needs a String
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
    
    private var deleteButton: some View {
        Button(role: .destructive) {
            editStepVM.deleteStep(step, context: context)
            dismiss()
        } label: {
            Text("Delete Step")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.bordered)
        .padding(.top, 8)
    }
    
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.footnote)
            .foregroundStyle(.secondary)
    }
    
    //reusable row button used for photo picker, remove and voice preview
    private func rowButton(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.12))
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: icon)
                        .foregroundStyle(.blue)
                }
            // fix styling
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
    
    //converts the optional voiceText into a String for the TextField
    private var voiceTextBinding: Binding<String> {
        Binding(
            get: {
                if step.voiceText == nil {
                    return ""
                }
                return step.voiceText!
            },
            set: { newValue in
                if newValue.isEmpty == true {
                    step.voiceText = nil
                } else {
                    step.voiceText = newValue
                }
                try? context.save()
            }
        )
    }
    
    private var shouldShowPreviewButton: Bool {
        if step.voiceText == nil {
            return false
        }
        if step.voiceText!.isEmpty == true {
            return false
        }
        return true
    }
    // preview icon here
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
            if step.voiceText != nil {
                speechService.speak(step.voiceText!)
            }
        }
    }
    
    //loads the photo data off the main thread so the ui doesnt freeze
    private func loadPhoto(_ item: PhotosPickerItem?) {
        
        if item == nil {
            return
        }
        
        Task {
            let loadedData = try? await item!.loadTransferable(type: Data.self)
            
            if loadedData != nil {
                step.photoData = loadedData
                try? context.save()
            }
        }
        
    }
    // add rmeoveing the photo
    
    private func removePhoto() {
        step.photoData = nil
        try? context.save()
    }
}
