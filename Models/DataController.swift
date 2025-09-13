//
//  DataController.swift
//  TogetherList
//

import CoreData
import CloudKit
import SwiftUI

class DataController: ObservableObject {
    static let shared = DataController()
    
    let container: NSPersistentCloudKitContainer
    
    @Published var activities: [Activity] = []
    @Published var completedCount = 0
    @Published var currentStreak = 0
    @Published var achievements: [Achievement] = []
    
    private init() {
        container = NSPersistentCloudKitContainer(name: "TogetherList")
        
        // Configure for CloudKit
        let storeURL = URL.storeURL(for: "group.com.yourcompany.TogetherList", databaseName: "TogetherList")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        
        // Configure CloudKit integration
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
            containerIdentifier: "iCloud.com.yourcompany.TogetherList"
        )
        
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Core Data error: \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Setup notifications for CloudKit changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(storeRemoteChange(_:)),
            name: .NSPersistentStoreRemoteChange,
            object: container.persistentStoreCoordinator
        )
        
        fetchActivities()
        checkAchievements()
    }
    
    @objc private func storeRemoteChange(_ notification: Notification) {
        DispatchQueue.main.async {
            self.fetchActivities()
        }
    }
    
    func fetchActivities() {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Activity.createdDate, ascending: false)]
        
        do {
            activities = try container.viewContext.fetch(request)
            completedCount = activities.filter { $0.status == ActivityStatus.completed.rawValue }.count
            calculateStreak()
        } catch {
            print("Error fetching activities: \(error)")
        }
    }
    
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
                fetchActivities()
                checkAchievements()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func addActivity(title: String, description: String, category: String, priority: String) {
        let newActivity = Activity(context: container.viewContext)
        newActivity.id = UUID()
        newActivity.title = title
        newActivity.activityDescription = description
        newActivity.category = category
        newActivity.priority = priority
        newActivity.status = ActivityStatus.planned.rawValue
        newActivity.createdDate = Date()
        newActivity.createdBy = UserSettings.shared.userID
        
        save()
        
        // Send notification to partner
        if let partnerID = UserSettings.shared.partnerID {
            NotificationManager.shared.sendPartnerNotification(
                title: "New Activity Added!",
                body: "\(UserSettings.shared.userName) added: \(title)",
                partnerID: partnerID
            )
        }
    }
    
    func completeActivity(_ activity: Activity, with images: [UIImage] = [], notes: String? = nil) {
        activity.status = ActivityStatus.completed.rawValue
        activity.completedDate = Date()
        activity.notes = notes
        
        // Save photos
        for image in images {
            PhotoManager.shared.savePhoto(image, for: activity)
        }
        
        save()
        
        // Send celebration notification
        if let partnerID = UserSettings.shared.partnerID {
            NotificationManager.shared.sendPartnerNotification(
                title: "Activity Completed! 🎉",
                body: "\(UserSettings.shared.userName) completed: \(activity.title ?? "")",
                partnerID: partnerID
            )
        }
    }
    
    func deleteActivity(_ activity: Activity) {
        container.viewContext.delete(activity)
        save()
    }
    
    private func calculateStreak() {
        let calendar = Calendar.current
        var streak = 0
        var currentDate = Date()
        let completed = activities.filter { $0.status == ActivityStatus.completed.rawValue }
        
        while true {
            let dayActivities = completed.filter { activity in
                if let completedDate = activity.completedDate {
                    return calendar.isDate(completedDate, inSameDayAs: currentDate)
                }
                return false
            }
            
            if dayActivities.isEmpty && !calendar.isDateInToday(currentDate) {
                break
            }
            
            if !dayActivities.isEmpty {
                streak += 1
            }
            
            guard let previousDate = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
            currentDate = previousDate
        }
        
        currentStreak = streak
    }
    
    private func checkAchievements() {
        var newAchievements: [Achievement] = []
        
        // First activity
        if completedCount == 1 {
            newAchievements.append(Achievement(
                id: UUID(),
                title: "First Step",
                description: "Completed your first activity together!",
                icon: "star.fill",
                unlockedDate: Date()
            ))
        }
        
        // 10 activities
        if completedCount == 10 {
            newAchievements.append(Achievement(
                id: UUID(),
                title: "Getting Started",
                description: "Completed 10 activities together!",
                icon: "flame.fill",
                unlockedDate: Date()
            ))
        }
        
        // 25 activities
        if completedCount == 25 {
            newAchievements.append(Achievement(
                id: UUID(),
                title: "Quarter Century",
                description: "25 memories and counting!",
                icon: "sparkles",
                unlockedDate: Date()
            ))
        }
        
        // 50 activities
        if completedCount == 50 {
            newAchievements.append(Achievement(
                id: UUID(),
                title: "Memory Masters",
                description: "50 incredible experiences together!",
                icon: "crown.fill",
                unlockedDate: Date()
            ))
        }
        
        // 7-day streak
        if currentStreak >= 7 && !achievements.contains(where: { $0.title == "Week Warrior" }) {
            newAchievements.append(Achievement(
                id: UUID(),
                title: "Week Warrior",
                description: "7-day activity streak!",
                icon: "calendar.badge.plus",
                unlockedDate: Date()
            ))
        }
        
        // 30-day streak
        if currentStreak >= 30 && !achievements.contains(where: { $0.title == "Monthly Champion" }) {
            newAchievements.append(Achievement(
                id: UUID(),
                title: "Monthly Champion",
                description: "30 days of adventures!",
                icon: "rosette",
                unlockedDate: Date()
            ))
        }
        
        // Category diversity
        let uniqueCategories = Set(activities.compactMap { $0.category })
        if uniqueCategories.count >= 5 && !achievements.contains(where: { $0.title == "Well Rounded" }) {
            newAchievements.append(Achievement(
                id: UUID(),
                title: "Well Rounded",
                description: "Tried activities in 5+ categories!",
                icon: "square.grid.3x3.fill",
                unlockedDate: Date()
            ))
        }
        
        achievements.append(contentsOf: newAchievements)
    }
}

// MARK: - URL Extension for App Group
extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let storeURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroup)?
            .appendingPathComponent("\(databaseName).sqlite") else {
            fatalError("Unable to create store URL")
        }
        return storeURL
    }
}