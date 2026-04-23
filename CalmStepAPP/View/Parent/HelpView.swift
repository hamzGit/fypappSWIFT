//
//  HelpView.swift
//  CalmSteps
//


import SwiftUI

struct HelpView: View {
    
    @ObservedObject var parentVM: ParentFlowViewModel

    private let developerName = "Hamza"
    private let developerEmail = "@my.westminster.ac.uk"
    private let universityName = "University of Westminster"
    private let courseName = "BSc (Hons) Computer Science"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        headerCard
                        howItWorksCard
                        aboutDeveloperCard
                    }
                    .padding()
                }
            }
            .navigationTitle("Help & About")
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
    

    
    //top thing
    
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Help & About")
                .font(.system(size: 18, weight: .bold))
            Text("meedt the developer")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.blue.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    
    private var howItWorksCard: some View {
        cardWrapper(title: "How CalmSteps Works") {
            VStack(alignment: .leading, spacing: 14) {
                
                guideRow(
                    icon: "play.circle.fill",
                    color: .blue,
                    title: "Starting a routine",
                    text: "Your child taps Start on the home screen. The app picks the right routine based on the time of day."
                )
                
                guideRow(
                    icon: "pause.circle.fill",
                    color: .purple,
                    title: "Taking breaks",
                    text: "The child can tap 'I Need a Break' at any time. We log it so you can see patterns in Insights."
                )
                
                guideRow(
                    icon: "square.and.pencil",
                    color: .orange,
                    title: "Customising steps",
                    text: "In Routines, tap a step to add a photo, adjust the timer, or record a voice instruction."
                )
                
                guideRow(
                    icon: "chart.bar.fill",
                    color: .green,
                    title: "Understanding Insights",
                    text: "See which steps cause the most breaks and how your child feels after each routine."
                )
            }
        }
    }
    
    

    
    private var aboutDeveloperCard: some View {
        cardWrapper(title: "About the Developer") {
            VStack(alignment: .center, spacing: 14) {
                
                // placeholder avata
                Circle()
                    .fill(Color.blue.opacity(0.18))
                    .frame(width: 90, height: 90)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.blue)
                    }
                
                Text(developerName)
                    .font(.system(size: 20, weight: .bold))
                
                // course + university on two centered lines
                Text("\(courseName)\n\(universityName)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                // the personal message
                Text("CalmSteps is my final-year project. I built it because I believe the right kind of digital support can make daily routines less overwhelming for autistic children and give parents a clearer picture of what helps. Thank you for using it.")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                    .padding(.top, 6)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
    }
    
    private func guideRow(icon: String, color: Color, title: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(color)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.semibold)
                Text(text)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }

    
    private func cardWrapper<Content: View>(title: String,
                                            @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    HelpView(parentVM: ParentFlowViewModel())
}
