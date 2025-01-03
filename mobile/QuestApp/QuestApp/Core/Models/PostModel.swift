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
    let content: String
    let imageUrl: String?
    let createdAt: String?
    var likes: [LikeModel]?
    let commentCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, userId, userName, content, imageUrl, createdAt, likes , commentCount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        userId = try container.decode(Int.self, forKey: .userId)
        userName = try container.decode(String?.self, forKey: .userName)
        content = try container.decode(String.self, forKey: .content)
        imageUrl = try container.decode(String?.self, forKey: .imageUrl)
        likes = try container.decode([LikeModel]?.self, forKey: .likes)
        createdAt = try container.decode(String?.self, forKey: .createdAt)
        commentCount = try container.decode(Int?.self, forKey: .commentCount)
    }
}

// Post detay sayfası için kullanılacak model
struct PostDetailModel: Codable, Identifiable {
    let id: Int
    let user: User
    let content: String
    let imageUrl: String?
    let createdAt: Date
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
    
    enum CodingKeys: String, CodingKey {
        case id, user, content, imageUrl, createdAt, likes, comments
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        user = try container.decode(User.self, forKey: .user)
        content = try container.decode(String.self, forKey: .content)
        imageUrl = try container.decode(String?.self, forKey: .imageUrl)
        likes = try container.decode([LikeModel]?.self, forKey: .likes)
        comments = try container.decode([CommentModel]?.self, forKey: .comments)
        
        let dateString = try container.decode(String.self, forKey: .createdAt)
        if let date = ISO8601DateFormatter().date(from: dateString) {
            createdAt = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .createdAt, in: container, debugDescription: "Date format is invalid")
        }
    }
}

struct User: Codable {
    let id: Int
    let name: String
    let password: String?
}

struct PostRequestModel: Codable {
    let content: String
    let imageUrl: String?
    
    init(content: String, imageUrl: String? = nil) {
        self.content = content
        self.imageUrl = imageUrl
    }
}
