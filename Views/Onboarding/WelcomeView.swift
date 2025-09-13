//
//  WelcomeView.swift
//  TogetherList
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.pink)
                
                Text("Together List")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Create shared memories with your partner")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 20) {
                FeatureRow(icon: "list.bullet", title: "Shared Bucket Lists", description: "Add activities you want to do together")
                FeatureRow(icon: "photo.on.rectangle", title: "Photo Memories", description: "Capture moments when you complete activities")
                FeatureRow(icon: "trophy.fill", title: "Achievements", description: "Unlock rewards as you build memories")
                FeatureRow(icon: "cloud.fill", title: "Real-time Sync", description: "Stay connected across all devices")
            }
            
            Spacer()
            
            Text("Swipe to continue")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.pink)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}