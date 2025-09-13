//
//  ActivityRow.swift
//  TogetherList
//

import SwiftUI

struct ActivityRow: View {
    let activity: Activity
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title ?? "")
                    .font(.headline)
                
                if let description = activity.activityDescription {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack {
                    if let category = activity.category {
                        Label(category, systemImage: categoryIcon)
                            .font(.caption)
                            .foregroundColor(categoryColor)
                    }
                    
                    Spacer()
                    
                    if let createdDate = activity.createdDate {
                        Text(createdDate, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            VStack {
                Image(systemName: statusIcon)
                    .foregroundColor(statusColor)
                    .font(.title3)
                
                if activity.status == ActivityStatus.planned.rawValue {
                    Button("Complete") {
                        dataController.completeActivity(activity)
                    }
                    .font(.caption)
                    .foregroundColor(.green)
                }
            }
        }
        .padding(.vertical, 4)
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