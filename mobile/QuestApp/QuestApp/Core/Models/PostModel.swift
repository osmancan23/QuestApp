//
//  PostModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 25.11.2024.
//

import Foundation



struct PostModel: Codable , Identifiable {
    let id, userID: Int?
    let userName, title, content: String?
    let likes: [LikeModel]?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case userName, title, content, likes
    }
}

struct LikeModel: Codable {
    let id, userID, postID: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case postID = "postId"
    }
}

