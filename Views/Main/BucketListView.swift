//
//  BucketListView.swift
//  TogetherList
//

import SwiftUI

struct BucketListView: View {
    @EnvironmentObject var dataController: DataController
    @State private var showingAddActivity = false
    @State private var selectedFilter = ActivityStatus.planned
    
    var filteredActivities: [Activity] {
        dataController.activities.filter { $0.status == selectedFilter.rawValue }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Filter Picker
                Picker("Status", selection: $selectedFilter) {
                    ForEach(ActivityStatus.allCases, id: \.self) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Activities List
                if filteredActivities.isEmpty {
                    EmptyStateView(
                        icon: "list.bullet",
                        title: "No Activities",
                        description: "Add your first activity to get started!"
                    )
                } else {
                    List {
                        ForEach(filteredActivities, id: \.id) { activity in
                            ActivityRow(activity: activity)
                        }
                        .onDelete(perform: deleteActivities)
                    }
                }
            }
            .navigationTitle("Bucket List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddActivity = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddActivity) {
                AddActivityView()
            }
        }
    }
    
    private func deleteActivities(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredActivities[$0] }.forEach(dataController.deleteActivity)
        }
    }
}