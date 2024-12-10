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

    var body: some View {
        switch destination {
        case .login:
            LoginView()
        case .register:
            RegisterView()
        case .feed:
            FeedView()
        case .postDetail(let post):
            PostDetailView(post: post)
       
        case .postCreate:
           PostCreateView()
        }
    }
}
