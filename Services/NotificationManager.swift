//
//  NotificationManager.swift
//  TogetherList
//

import UserNotifications
import CloudKit

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var hasPermission = false
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.hasPermission = granted
            }
            
            if granted {
                self.setupNotificationCategories()
                self.scheduleDailyReminder()
            }
        }
    }
    
    private func setupNotificationCategories() {
        let completeAction = UNNotificationAction(
            identifier: "COMPLETE_ACTION",
            title: "Mark Complete",
            options: .foreground
        )
        
        let viewAction = UNNotificationAction(
            identifier: "VIEW_ACTION",
            title: "View",
            options: .foreground
        )
        
        let activityCategory = UNNotificationCategory(
            identifier: "ACTIVITY_CATEGORY",
            actions: [completeAction, viewAction],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([activityCategory])
    }
    
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Check-in"
        content.body = "Don't forget to add or complete an activity today!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19 // 7 PM
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily-reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func sendPartnerNotification(title: String, body: String, partnerID: UUID) {
        // This would send via CloudKit/APNs to partner's device
        let notification = CKNotification()
        notification.alertBody = body
        notification.soundName = "default"
        
        // In production, this would use CloudKit to send to partner
    }
    
    func sendAchievementNotification(_ achievement: Achievement) {
        let content = UNMutableNotificationContent()
        content.title = "Achievement Unlocked! 🏆"
        content.body = "\(achievement.title): \(achievement.description)"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}