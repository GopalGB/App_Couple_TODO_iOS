//
//  Enums.swift
//  TogetherList
//

import SwiftUI

enum ActivityCategory: String, CaseIterable {
    case adventure = "Adventure"
    case romance = "Romance"
    case travel = "Travel"
    case food = "Food"
    case entertainment = "Entertainment"
    case fitness = "Fitness"
    case learning = "Learning"
    case creative = "Creative"
    
    var icon: String {
        switch self {
        case .adventure: return "mountain.2.fill"
        case .romance: return "heart.fill"
        case .travel: return "airplane"
        case .food: return "fork.knife"
        case .entertainment: return "ticket.fill"
        case .fitness: return "figure.run"
        case .learning: return "book.fill"
        case .creative: return "paintbrush.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .adventure: return .orange
        case .romance: return .pink
        case .travel: return .blue
        case .food: return .green
        case .entertainment: return .purple
        case .fitness: return .red
        case .learning: return .indigo
        case .creative: return .yellow
        }
    }
}

enum ActivityStatus: String, CaseIterable {
    case planned = "Planned"
    case inProgress = "In Progress"
    case completed = "Completed"
    
    var icon: String {
        switch self {
        case .planned: return "calendar"
        case .inProgress: return "hourglass"
        case .completed: return "checkmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .planned: return .blue
        case .inProgress: return .orange
        case .completed: return .green
        }
    }
}

enum Priority: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .low: return .gray
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .low: return "flag"
        case .medium: return "flag.fill"
        case .high: return "exclamationmark.triangle.fill"
        }
    }
}