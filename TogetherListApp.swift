//
//  TogetherListApp.swift
//  TogetherList
//
//  Production-ready couples bucket list app
//

import SwiftUI
import CloudKit

@main
struct TogetherListApp: App {
    @StateObject private var dataController = DataController.shared
    @StateObject private var userSettings = UserSettings.shared
    @StateObject private var cloudKitManager = CloudKitManager.shared
    @StateObject private var notificationManager = NotificationManager.shared
    
    init() {
        // Configure app appearance
        configureAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(userSettings)
                .environmentObject(cloudKitManager)
                .environmentObject(notificationManager)
                .onAppear {
                    notificationManager.requestAuthorization()
                    cloudKitManager.setupCloudKit()
                }
        }
    }
    
    private func configureAppearance() {
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Configure tab bar appearance
        UITabBar.appearance().backgroundColor = UIColor.systemBackground
    }
}