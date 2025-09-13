//
//  UserSettings.swift
//  TogetherList
//

import Foundation
import SwiftUI

class UserSettings: ObservableObject {
    static let shared = UserSettings()
    
    @AppStorage("userID") var userID: UUID = UUID()
    @AppStorage("userName") var userName: String = ""
    @AppStorage("connectionCode") var connectionCode: String = ""
    @AppStorage("partnerID") var partnerID: UUID?
    @AppStorage("partnerName") var partnerName: String = ""
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("profileImageData") var profileImageData: Data?
    
    @Published var isConnected: Bool = false
    
    private init() {
        if connectionCode.isEmpty {
            connectionCode = generateCode()
        }
        checkConnection()
    }
    
    func generateCode() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map { _ in letters.randomElement()! })
    }
    
    func checkConnection() {
        isConnected = partnerID != nil
    }
    
    func connectWithPartner(code: String) async throws {
        // This would connect to CloudKit to find and link partner
        await CloudKitManager.shared.connectWithPartner(code: code)
        checkConnection()
    }
    
    func disconnectPartner() {
        partnerID = nil
        partnerName = ""
        checkConnection()
    }
    
    func updateProfile(name: String, imageData: Data?) {
        userName = name
        profileImageData = imageData
        CloudKitManager.shared.updateUserProfile()
    }
}