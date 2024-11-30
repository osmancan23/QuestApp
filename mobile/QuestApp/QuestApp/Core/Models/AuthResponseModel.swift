//
//  AuthResponseModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 30.11.2024.
//

import Foundation


struct AuthResponseModel: Codable {
    let message: String?
    let userId: Int
    let accessToken: String
    let refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case message
        case userId
        case accessToken, refreshToken
    }
}
