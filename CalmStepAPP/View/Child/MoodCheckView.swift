import SwiftUI
import SwiftData

struct MoodCheckView: View {
    
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
                
                Spacer().frame(height: 30)
                
                Text("How do you feel?")
                    .font(.system(size: 28, weight: .bold))
                
                Text("Tap the face that matches your mood")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if settings?.showCharacter == true {
                    VStack(spacing: 16) {
                        Button {
                            childVM.recordMood("happy", context: context)
                        } label: {
                            CharacterView(scene: .moodHappy)
                                .frame(width: 180, height: 180)
                        }
                        
                        Button {
                            childVM.recordMood("okay", context: context)
                        } label: {
                            CharacterView(scene: .moodNeutral)
                                .frame(width: 180, height: 180)
                        }
                        
                        Button {
                            childVM.recordMood("sad", context: context)
                        } label: {
                            CharacterView(scene: .moodSad)
                                .frame(width: 180, height: 180)
                        }
                    }
                } else {
                    VStack(spacing: 16) {
                        Button { childVM.recordMood("happy", context: context) } label: {
                            Text("😊").font(.system(size: 64))
                        }
                        Button { childVM.recordMood("okay", context: context) } label: {
                            Text("😐").font(.system(size: 64))
                        }
                        Button { childVM.recordMood("sad", context: context) } label: {
                            Text("😢").font(.system(size: 64))
                        }
                    }
                }
                
                Spacer()
                
                Button("Not Right Now") {
                    childVM.recordMood(nil, context: context)
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    MoodCheckView(childVM: ChildFlowViewModel())
}
