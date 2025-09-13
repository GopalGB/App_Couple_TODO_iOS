//
//  ActivityCard.swift
//  TogetherList
//

import SwiftUI

struct ActivityCard: View {
    let activity: Activity
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: categoryIcon)
                    .foregroundColor(categoryColor)
                
                Text(activity.category ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Image(systemName: statusIcon)
                    .foregroundColor(statusColor)
            }
            
            Text(activity.title ?? "")
                .font(.headline)
                .lineLimit(2)
            
            if let description = activity.activityDescription {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            HStack {
                if let createdDate = activity.createdDate {
                    Text(createdDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if activity.status == ActivityStatus.planned.rawValue {
                    Button("Complete") {
                        dataController.completeActivity(activity)
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.green)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
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