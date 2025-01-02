import SwiftUI

struct MainTabView: View {
    @StateObject private var authManager: AuthManager
    @EnvironmentObject var router: Router
    @State private var showingCreatePost = false
    
    init(authManager: AuthManager) {
        _authManager = StateObject(wrappedValue: authManager)
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                FeedView(authManager: authManager)
            }
            .tabItem {
                Label("Ana Sayfa", systemImage: "house.fill")
            }
            
            NavigationStack {
                PostCreateView(isPresented: $showingCreatePost, onPost: { title, content in
                    // Post oluşturma işlemi
                })
            }
            .tabItem {
                Label("Paylaş", systemImage: "plus.circle.fill")
            }
            
            NavigationStack {
                ProfileView(authManager: authManager)
            }
            .tabItem {
                Label("Profil", systemImage: "person.fill")
            }
        }
        .accentColor(.blue)
    }
} 
