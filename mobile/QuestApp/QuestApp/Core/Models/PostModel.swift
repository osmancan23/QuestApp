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
    var likes: [Like]?
    let commentCount: Int?
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, userId, userName, content, imageUrl, createdAt, likes, commentCount, isLiked
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        userId = try container.decode(Int.self, forKey: .userId)
        userName = try container.decode(String?.self, forKey: .userName)
        content = try container.decode(String.self, forKey: .content)
        imageUrl = try container.decode(String?.self, forKey: .imageUrl)
        likes = try container.decode([Like]?.self, forKey: .likes)
        createdAt = try container.decode(String?.self, forKey: .createdAt)
        commentCount = try container.decode(Int?.self, forKey: .commentCount)
        isLiked = try container.decode(Bool.self, forKey: .isLiked)
    }
}

// Post detay sayfası için kullanılacak model
struct PostDetailModel: Codable, Identifiable {
    let id: Int
    let userId: Int?
    let userName: String?
    let content: String
    let imageUrl: String?
    let createdAt: String?
    var likes: [Like]?
    var comments: [CommentModel]?
    let commentCount: Int?
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, userId, userName, content, imageUrl, createdAt, likes, comments, commentCount, isLiked
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        userId = try container.decode(Int?.self, forKey: .userId)
        userName = try container.decode(String?.self, forKey: .userName)
        content = try container.decode(String.self, forKey: .content)
        imageUrl = try container.decode(String?.self, forKey: .imageUrl)
        likes = try container.decode([Like]?.self, forKey: .likes)
        comments = try container.decode([CommentModel]?.self, forKey: .comments)
        commentCount = try container.decode(Int?.self, forKey: .commentCount)
        createdAt = try container.decode(String?.self, forKey: .createdAt)
        isLiked = try container.decode(Bool.self, forKey: .isLiked)
    }
}

struct User: Codable {
    let id: Int
    let name: String
    let password: String?
    let postCount: Int?
}

struct PostRequestModel: Codable {
    let content: String
    let imageUrl: String?
    
    init(content: String, imageUrl: String? = nil) {
        self.content = content
        self.imageUrl = imageUrl
    }
}
