//
//  AchievementsView.swift
//  TogetherList
//

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            if dataController.achievements.isEmpty {
                EmptyStateView(
                    icon: "trophy.fill",
                    title: "No Achievements Yet",
                    description: "Complete activities to unlock achievements and rewards!"
                )
            } else {
                List {
                    ForEach(dataController.achievements) { achievement in
                        HStack(spacing: 15) {
                            Image(systemName: achievement.icon)
                                .font(.title2)
                                .foregroundColor(.yellow)
                                .frame(width: 40, height: 40)
                                .background(Color.yellow.opacity(0.1))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(achievement.title)
                                    .font(.headline)
                                
                                Text(achievement.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("Unlocked \(achievement.unlockedDate, style: .date)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}