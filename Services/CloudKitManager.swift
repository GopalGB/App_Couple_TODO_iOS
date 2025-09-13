//
//  CloudKitManager.swift
//  TogetherList
//

import CloudKit
import SwiftUI

class CloudKitManager: ObservableObject {
    static let shared = CloudKitManager()
    
    private let container = CKContainer(identifier: "iCloud.com.yourcompany.TogetherList")
    private let database = CKContainer(identifier: "iCloud.com.yourcompany.TogetherList").publicCloudDatabase
    
    @Published var isSyncing = false
    @Published var syncError: Error?
    
    private init() {
        setupSubscriptions()
    }
    
    func setupCloudKit() {
        // Request permission
        container.requestApplicationPermission(.userDiscoverability) { status, error in
            if let error = error {
                print("CloudKit permission error: \(error)")
            }
        }
        
        // Verify account status
        container.accountStatus { status, error in
            switch status {
            case .available:
                self.createUserRecordIfNeeded()
            case .noAccount:
                print("No iCloud account")
            case .restricted, .couldNotDetermine:
                print("CloudKit restricted or undetermined")
            default:
                break
            }
        }
    }
    
    private func createUserRecordIfNeeded() {
        let userRecord = CKRecord(recordType: "User")
        userRecord["userID"] = UserSettings.shared.userID.uuidString
        userRecord["userName"] = UserSettings.shared.userName
        userRecord["connectionCode"] = UserSettings.shared.connectionCode
        
        database.save(userRecord) { record, error in
            if let error = error as? CKError, error.code != .serverRecordChanged {
                print("Error saving user record: \(error)")
            }
        }
    }
    
    func connectWithPartner(code: String) async {
        let predicate = NSPredicate(format: "connectionCode == %@", code)
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        do {
            let results = try await database.records(matching: query)
            
            if let partnerRecord = results.matchResults.first?.1.get() {
                if let partnerID = partnerRecord["userID"] as? String,
                   let partnerName = partnerRecord["userName"] as? String {
                    
                    await MainActor.run {
                        UserSettings.shared.partnerID = UUID(uuidString: partnerID)
                        UserSettings.shared.partnerName = partnerName
                        UserSettings.shared.checkConnection()
                    }
                    
                    // Create connection record
                    createConnectionRecord(partnerID: partnerID)
                }
            }
        } catch {
            print("Error connecting with partner: \(error)")
            await MainActor.run {
                self.syncError = error
            }
        }
    }
    
    private func createConnectionRecord(partnerID: String) {
        let connectionRecord = CKRecord(recordType: "Connection")
        connectionRecord["user1ID"] = UserSettings.shared.userID.uuidString
        connectionRecord["user2ID"] = partnerID
        connectionRecord["connectedDate"] = Date()
        
        database.save(connectionRecord) { record, error in
            if let error = error {
                print("Error creating connection: \(error)")
            }
        }
    }
    
    private func setupSubscriptions() {
        // Subscribe to partner's activity changes
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(
            recordType: "Activity",
            predicate: predicate,
            subscriptionID: "activity-changes",
            options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion]
        )
        
        let notification = CKSubscription.NotificationInfo()
        notification.alertBody = "Your partner updated an activity!"
        notification.shouldBadge = true
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        
        database.save(subscription) { subscription, error in
            if let error = error {
                print("Error creating subscription: \(error)")
            }
        }
    }
    
    func updateUserProfile() {
        let predicate = NSPredicate(format: "userID == %@", UserSettings.shared.userID.uuidString)
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        database.fetch(withQuery: query) { result in
            switch result {
            case .success(let results):
                if let record = try? results.matchResults.first?.1.get() {
                    record["userName"] = UserSettings.shared.userName
                    if let imageData = UserSettings.shared.profileImageData {
                        record["profileImage"] = CKAsset(data: imageData)
                    }
                    
                    self.database.save(record) { _, error in
                        if let error = error {
                            print("Error updating profile: \(error)")
                        }
                    }
                }
            case .failure(let error):
                print("Error fetching user record: \(error)")
            }
        }
    }
}

// MARK: - CKAsset Extension
extension CKAsset {
    convenience init?(data: Data) {
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        do {
            try data.write(to: tempURL)
            self.init(fileURL: tempURL)
        } catch {
            return nil
        }
    }
}