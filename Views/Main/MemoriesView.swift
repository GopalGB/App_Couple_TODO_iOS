//
//  MemoriesView.swift
//  TogetherList
//

import SwiftUI

struct MemoriesView: View {
    @EnvironmentObject var dataController: DataController
    
    var completedActivities: [Activity] {
        dataController.activities.filter { $0.status == ActivityStatus.completed.rawValue }
            .sorted { ($0.completedDate ?? Date.distantPast) > ($1.completedDate ?? Date.distantPast) }
    }
    
    var body: some View {
        NavigationView {
            if completedActivities.isEmpty {
                EmptyStateView(
                    icon: "photo.on.rectangle",
                    title: "No Memories Yet",
                    description: "Complete activities to create beautiful memories together!"
                )
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 15) {
                    ForEach(completedActivities, id: \.id) { activity in
                        MemoryCard(activity: activity)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Memories")
    }
}