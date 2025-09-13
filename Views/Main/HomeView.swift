//
//  HomeView.swift
//  TogetherList
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var userSettings: UserSettings
    @State private var showingAddActivity = false
    @State private var showingAchievements = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Welcome Header
                    headerSection
                    
                    // Stats Cards
                    statsSection
                    
                    // Recent Achievements
                    if !dataController.achievements.isEmpty {
                        achievementsSection
                    }
                    
                    // Suggested Activities
                    suggestedSection
                    
                    // Recent Memories
                    if !dataController.activities.filter({ $0.status == ActivityStatus.completed.rawValue }).isEmpty {
                        memoriesSection
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Together List")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingAddActivity) {
                AddActivityView()
            }
            .sheet(isPresented: $showingAchievements) {
                AchievementsView()
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Hello, \(userSettings.userName)!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if userSettings.isConnected {
                    Label("Connected with \(userSettings.partnerName)", systemImage: "link")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Label("Not Connected", systemImage: "link.badge.plus")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            Spacer()
            
            Button(action: { showingAddActivity = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.pink)
            }
        }
        .padding(.horizontal)
    }
    
    private var statsSection: some View {
        HStack(spacing: 15) {
            StatCard(
                title: "Completed",
                value: "\(dataController.completedCount)",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            StatCard(
                title: "Streak",
                value: "\(dataController.currentStreak) days",
                icon: "flame.fill",
                color: .orange
            )
            
            StatCard(
                title: "Total",
                value: "\(dataController.activities.count)",
                icon: "list.bullet",
                color: .blue
            )
        }
        .padding(.horizontal)
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Recent Achievements")
                    .font(.headline)
                Spacer()
                Button("See All") {
                    showingAchievements = true
                }
                .font(.caption)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(dataController.achievements.prefix(5)) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var suggestedSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Suggested for You")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(getSuggestedActivities(), id: \.title) { suggestion in
                SuggestedActivityCard(
                    title: suggestion.title,
                    description: suggestion.description,
                    category: suggestion.category,
                    action: {
                        dataController.addActivity(
                            title: suggestion.title,
                            description: suggestion.description,
                            category: suggestion.category.rawValue,
                            priority: Priority.medium.rawValue
                        )
                    }
                )
            }
        }
    }
    
    private var memoriesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Memories")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(dataController.activities.filter { $0.status == ActivityStatus.completed.rawValue }.prefix(5)) { activity in
                        RecentMemoryCard(activity: activity)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func getSuggestedActivities() -> [(title: String, description: String, category: ActivityCategory)] {
        let allSuggestions = [
            (title: "Sunset Picnic", description: "Watch the sunset together with your favorite snacks", category: ActivityCategory.romance),
            (title: "Cooking Challenge", description: "Try making a new recipe together", category: ActivityCategory.food),
            (title: "Nature Hike", description: "Explore a nearby trail or park", category: ActivityCategory.adventure),
            (title: "Game Night", description: "Play board games or video games together", category: ActivityCategory.entertainment),
            (title: "Workout Together", description: "Try a new exercise routine or sport", category: ActivityCategory.fitness),
            (title: "Learn Something New", description: "Take an online class together", category: ActivityCategory.learning),
            (title: "Art Project", description: "Create something beautiful together", category: ActivityCategory.creative),
            (title: "Weekend Getaway", description: "Plan a short trip to a nearby city", category: ActivityCategory.travel)
        ]
        
        // Filter out already added activities
        let existingTitles = Set(dataController.activities.map { $0.title ?? "" })
        return allSuggestions.filter { !existingTitles.contains($0.title) }.prefix(3).map { $0 }
    }
}