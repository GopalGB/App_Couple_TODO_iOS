//
//  ActivityDetailView.swift
//  TogetherList
//

import SwiftUI

struct ActivityDetailView: View {
    let activity: Activity
    @EnvironmentObject var dataController: DataController
    @State private var showingCompleteSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: categoryIcon)
                            .foregroundColor(categoryColor)
                        Text(activity.category ?? "")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: statusIcon)
                                .foregroundColor(statusColor)
                            Text(activity.status ?? "")
                                .foregroundColor(statusColor)
                        }
                    }
                    
                    Text(activity.title ?? "")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let description = activity.activityDescription {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Dates
                VStack(alignment: .leading, spacing: 10) {
                    if let createdDate = activity.createdDate {
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                                .foregroundColor(.blue)
                            Text("Created: \(createdDate, style: .date)")
                        }
                    }
                    
                    if let completedDate = activity.completedDate {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Completed: \(completedDate, style: .date)")
                        }
                    }
                }
                
                // Notes
                if let notes = activity.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Notes")
                            .font(.headline)
                        Text(notes)
                            .font(.body)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                
                // Photos
                if let photos = activity.photos?.allObjects as? [Photo], !photos.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Photos")
                            .font(.headline)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 10) {
                            ForEach(photos, id: \.id) { photo in
                                if let imageData = photo.imageData,
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 100)
                                        .clipped()
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if activity.status == ActivityStatus.planned.rawValue {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Complete") {
                        showingCompleteSheet = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingCompleteSheet) {
            CompleteActivityView(activity: activity)
        }
    }
    
    private var categoryIcon: String {
        guard let category = activity.category,
              let activityCategory = ActivityCategory(rawValue: category) else {
            return "questionmark"
        }
        return activityCategory.icon
    }
    
    private var categoryColor: Color {
        guard let category = activity.category,
              let activityCategory = ActivityCategory(rawValue: category) else {
            return .gray
        }
        return activityCategory.color
    }
    
    private var statusIcon: String {
        guard let status = activity.status,
              let activityStatus = ActivityStatus(rawValue: status) else {
            return "questionmark"
        }
        return activityStatus.icon
    }
    
    private var statusColor: Color {
        guard let status = activity.status,
              let activityStatus = ActivityStatus(rawValue: status) else {
            return .gray
        }
        return activityStatus.color
    }
}