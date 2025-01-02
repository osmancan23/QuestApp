//
//  PostModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 25.11.2024.
//

import Foundation

// Ana sayfa için kullanılacak model
struct PostListModel: Codable, Identifiable {
    let id: Int
    let userId: Int
    let userName: String?
    let title: String
    let content: String
    var likes: [LikeModel]?
    var comments: [CommentModel]?
}

// Post detay sayfası için kullanılacak model
struct PostDetailModel: Codable, Identifiable {
    let id: Int
    let user: User
    let title: String
    let content: String
    var likes: [LikeModel]?
    var comments: [CommentModel]?
    
    // Computed property for userId
    var userId: Int {
        return user.id
    }
    
    // Computed property for userName
    var userName: String {
        return user.name
    }
}

struct User: Codable {
    let id: Int
    let name: String
    let password: String?
}

struct PostRequestModel: Codable {
    let title: String
    let content: String
}
