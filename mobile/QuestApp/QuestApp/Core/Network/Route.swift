//
//  Route.swift
//  ShopApp-SwiftUI
//
//  Created by Osmancan Akagündüz on 6.09.2024.
//

import Foundation

enum Route {

    static let baseUrl = "http://localhost:8080/"

    case login

    case register

    case posts


    var value: String {

        switch self {

        case .login: return "auth/login"

        case .register: return "auth/register"


        case .posts: return "posts"




        }
    }

}
