import SwiftUI

struct RewardView: View {
    
    @ObservedObject var childVM: ChildFlowViewModel
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                Spacer()
                
                // star
                Circle()
                    .fill(Color.yellow.opacity(0.20))
                    .frame(width: 150, height: 150)
                    .overlay {
                        Image(systemName: "star.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.yellow)
                    }
                
                Text("Well Done!")
                    .font(.system(size: 36, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("You finished your routine.")
                    .font(.system(size: 18))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                PrimaryButton(title: "Go Home") {
                    childVM.returnHome()
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    RewardView(childVM: ChildFlowViewModel())
}
