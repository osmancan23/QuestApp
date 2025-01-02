//
//  NavigationViewBuilder.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 10.12.2024.
//

import Foundation
import SwiftUI

struct NavigationViewBuilder: View {
    var destination: Router.Destination
    @ObservedObject var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingCreatePost: Bool = true
    
    var body: some View {
        switch destination {
        case .login:
            LoginView(authManager: authManager)
        case .register:
            RegisterView(authManager: authManager)
        case .feed:
            FeedView(authManager: authManager)
        case .postDetail(let post):
            PostDetailView(postId: post)
        case .postCreate:
            PostCreateView(isPresented: $showingCreatePost, onPost: { title, content in
                // Post oluşturma işlemi tamamlandığında
                dismiss()
            })
            .onChange(of: showingCreatePost) { newValue in
                if !newValue {
                    dismiss()
                }
            }
        case .profile:
            ProfileView(authManager: authManager)
        }
    }
}
