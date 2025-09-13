//
//  MainTabView.swift
//  TogetherList
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            BucketListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Bucket List")
                }
            
            MemoriesView()
                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("Memories")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(.pink)
    }
}