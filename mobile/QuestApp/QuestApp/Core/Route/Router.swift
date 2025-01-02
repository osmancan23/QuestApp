//
//  Navigation.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 2.12.2024.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {

    @Published var path = NavigationPath()

    // Add the views you need to control
    public enum Destination: Hashable {
        case login
        case register
        case feed
        case postDetail(postId: Int) // PostModel yerine sadece id kullanıyoruz
        case postCreate
        case profile
        
        // Hashable gereksinimleri için
        func hash(into hasher: inout Hasher) {
            switch self {
            case .login:
                hasher.combine(0)
            case .register:
                hasher.combine(1)
            case .feed:
                hasher.combine(2)
            case .postDetail(let postId):
                hasher.combine(3)
                hasher.combine(postId)
            case .postCreate:
                hasher.combine(4)
            case .profile:
                hasher.combine(5)
            }
        }
        
        // Equatable gereksinimleri için
        static func == (lhs: Router.Destination, rhs: Router.Destination) -> Bool {
            switch (lhs, rhs) {
            case (.login, .login):
                return true
            case (.register, .register):
                return true
            case (.feed, .feed):
                return true
            case (.postDetail(let id1), .postDetail(let id2)):
                return id1 == id2
            case (.postCreate, .postCreate):
                return true
            case (.profile, .profile):
                return true
            default:
                return false
            }
        }
    }



    func navigate(to destination: Destination) {
        path.append(destination)
    }

    func navigateBack() {
        path.removeLast()
    }

    func navigateToRoot() {
        path.removeLast(path.count)
    }

    func navigateAndReplace(to destination: Destination) {
        path = NavigationPath()
        path.append(destination)
    }
}
