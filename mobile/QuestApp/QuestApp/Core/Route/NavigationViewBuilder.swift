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

    var body: some View {
        switch destination {
        case .login:
            LoginView(authManager: authManager)
        case .register:
            RegisterView()
        case .feed:
            FeedView(authManager: authManager)
        case .postDetail(let post):
            PostDetailView(post: post)
       
        case .postCreate:
           PostCreateView()
        }
    }
}
