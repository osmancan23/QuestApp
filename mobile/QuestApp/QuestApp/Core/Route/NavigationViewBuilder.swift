//
//  NavigationViewBuilder.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 10.12.2024.
//

import Foundation
import SwiftUI

struct NavigationViewBuilder {
    @ViewBuilder
    static func build(for destination: Router.Destination, authManager: AuthManager) -> some View {
        switch destination {
        case .login:
            LoginView(authManager: authManager)
        case .register:
            RegisterView(authManager: authManager)
        case .feed:
            FeedView(authManager: authManager)
        case .profile:
            ProfileView(authManager: authManager)
        case .postDetail(let postId):
            PostDetailView(postId: postId)
        case .postCreate:
            PostCreateView()
        }
    }
}
