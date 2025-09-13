//
//  ConnectionView.swift
//  TogetherList
//

import SwiftUI

struct ConnectionView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var partnerCode = ""
    @State private var isConnecting = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Connect with Partner")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Text("Your Code")
                        .font(.headline)
                    
                    Text(userSettings.connectionCode)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    
                    Text("Share this code with your partner")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("OR")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 10) {
                    Text("Enter Partner's Code")
                        .font(.headline)
                    
                    TextField("Partner's Code", text: $partnerCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title3)
                        .textCase(.uppercase)
                        .autocapitalization(.allCharacters)
                        .disableAutocorrection(true)
                }
            }
            
            if userSettings.isConnected {
                VStack(spacing: 15) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                    
                    Text("Connected!")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("You're now connected with \(userSettings.partnerName)")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
            
            VStack(spacing: 15) {
                if !userSettings.isConnected {
                    Button("Connect") {
                        connectWithPartner()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(partnerCode.count == 6 ? Color.pink : Color.gray)
                    .cornerRadius(12)
                    .disabled(partnerCode.count != 6 || isConnecting)
                    .overlay(
                        Group {
                            if isConnecting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                        }
                    )
                    
                    Button("Skip for Now") {
                        userSettings.hasCompletedOnboarding = true
                    }
                    .foregroundColor(.secondary)
                } else {
                    Button("Get Started") {
                        userSettings.hasCompletedOnboarding = true
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .alert("Connection Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func connectWithPartner() {
        isConnecting = true
        
        Task {
            do {
                try await userSettings.connectWithPartner(code: partnerCode)
                await MainActor.run {
                    isConnecting = false
                }
            } catch {
                await MainActor.run {
                    isConnecting = false
                    errorMessage = "Failed to connect with partner. Please check the code and try again."
                    showingError = true
                }
            }
        }
    }
}