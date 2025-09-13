//
//  ProfileView.swift
//  TogetherList
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var dataController: DataController
    @State private var showingConnectionView = false
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            List {
                // Profile Section
                Section {
                    HStack {
                        AsyncImage(url: profileImageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(userSettings.userName.isEmpty ? "Your Name" : userSettings.userName)
                                .font(.headline)
                            Text("Code: \(userSettings.connectionCode)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Edit") {
                            showingEditProfile = true
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Connection Section
                Section("Connection") {
                    if userSettings.isConnected {
                        HStack {
                            Image(systemName: "link")
                                .foregroundColor(.green)
                            Text("Connected with \(userSettings.partnerName)")
                            Spacer()
                            Button("Disconnect") {
                                userSettings.disconnectPartner()
                            }
                            .foregroundColor(.red)
                        }
                    } else {
                        Button("Connect with Partner") {
                            showingConnectionView = true
                        }
                    }
                }
                
                // Stats Section
                Section("Statistics") {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Completed Activities")
                        Spacer()
                        Text("\(dataController.completedCount)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("Current Streak")
                        Spacer()
                        Text("\(dataController.currentStreak) days")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.blue)
                        Text("Total Activities")
                        Spacer()
                        Text("\(dataController.activities.count)")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Achievements Section
                Section("Achievements") {
                    if dataController.achievements.isEmpty {
                        Text("No achievements yet")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(dataController.achievements) { achievement in
                            HStack {
                                Image(systemName: achievement.icon)
                                    .foregroundColor(.yellow)
                                VStack(alignment: .leading) {
                                    Text(achievement.title)
                                        .font(.headline)
                                    Text(achievement.description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(achievement.unlockedDate, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showingConnectionView) {
                ConnectionView()
            }
            .sheet(isPresented: $showingEditProfile) {
                ProfileSetupView()
            }
        }
    }
    
    private var profileImageURL: URL? {
        // Return URL for profile image if available
        return nil
    }
}