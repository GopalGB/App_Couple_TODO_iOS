//
//  OnboardingView.swift
//  TogetherList
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0
    
    var body: some View {
        TabView(selection: $currentStep) {
            WelcomeView()
                .tag(0)
            
            ProfileSetupView()
                .tag(1)
            
            ConnectionView()
                .tag(2)
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}