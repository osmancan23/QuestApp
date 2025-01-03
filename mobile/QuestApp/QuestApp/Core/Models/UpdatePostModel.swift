//
//  UpdatePostModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 30.11.2024.
//

import Foundation

struct UpdatePostModel: Codable {
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case content
    }
}
    
