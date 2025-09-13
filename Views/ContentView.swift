//
//  ContentView.swift
//  TogetherList
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        if userSettings.hasCompletedOnboarding {
            MainTabView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    dataController.fetchActivities()
                }
        } else {
            OnboardingView()
        }
    }
}