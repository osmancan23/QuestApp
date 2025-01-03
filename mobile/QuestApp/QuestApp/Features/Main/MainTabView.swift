import SwiftUI

struct MainTabView: View {
    @StateObject private var authManager = AuthManager()
    @State private var showingCreatePost = false
    
    var body: some View {
        TabView {
            FeedView(authManager: authManager)
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house.fill")
                }
            
            PostCreateView()
                .tabItem {
                    Label("Paylaş", systemImage: "plus.app")
                }
            
            ProfileView(authManager: authManager)
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
        }
        .sheet(isPresented: $showingCreatePost) {
            PostCreateView()
        }
    }
} 
