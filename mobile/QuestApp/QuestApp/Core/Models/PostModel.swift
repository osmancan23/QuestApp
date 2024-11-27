//
//  PostModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 25.11.2024.
//

import Foundation

/*
 Long id;
   Long userId;
   String userName;
   String title;
   String content;
   List<LikeResponse> likes;
 */



struct PostModel: Identifiable {
    
    
    
    var id: Int
    var userId: Int
    var userName: String
    var title: String
    var content: String
    var likes: [LikeModel]
    
   
    
    
    
    
}
