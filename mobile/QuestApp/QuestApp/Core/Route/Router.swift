//
//  Navigation.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 2.12.2024.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {

    @Published var path = NavigationPath() {
        willSet {
            print("Path will change: \(path) -> \(newValue)")
        }
    }

    // Add the views you need to control
    public enum Destination: Hashable {
        case login
        case register
        case feed
        case postDetail(post: PostModel) // PostModel yerine basit bir ID kullanın
        case postCreate
    }



    func navigate(to destination: Destination) {
        print("Navigating to: \(destination)")
        path.append(destination)
        print("Updated Path: \(path)")
    }

    func navigateBack() {
        path.removeLast()
    }

    func navigateToRoot() {
        path.removeLast(path.count)
    }

    func navigateAndReplace(to destination: Destination) {
        path = NavigationPath() // Yolu sıfırla
        path.append(destination) // Yeni hedefe git
    }
}