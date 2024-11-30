//
//  PostCard.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 25.11.2024.
//

import Foundation
import UIKit
import SwiftUI

struct PostCard: View {
    var post: PostModel
    var body: some View {
        VStack(alignment: .leading) { // Sola dayalı hizalama için alignment ayarlandı
            // Profil resmi ve kullanıcı bilgileri
            HStack(alignment: .center) {
                Image("login")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) { // Sol hizalama için alignment eklendi
                    Text(post.userName ?? "Unknown")
                        .font(.headline)
                        .fontWeight(.medium)
                    Text("Yesterday at 10:00 PM")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                .padding(.leading, 10)
            }
            .padding(.leading, 10)
            .padding(.bottom, 10)
            
            // Post içeriği
            Text(post.content ?? "-")
                .padding(.leading, 10)
                .padding(.bottom, 10)
            
            // Düğmeler
            HStack {
                PostButtonView(type: .like, count: post.likes?.count ?? 0)
                PostButtonView(type: .comment, count: 15)
            }
            .padding(.leading, 10)
        }
        .frame(width: 400, height: 200, alignment: .leading)// Kutunun hizalaması sola çekildi
        
    }
}


/*
#Preview{
    PostCard(post: PostModelElement(id: 1, userId: 1, userName: "dsad", title: "dsaadsasd", content: "dadasdasd", likes: [LikeModel(id: 1, userId: 1, postId: 1)]))
}
*/

enum PostButtonType {
    case like
    case comment

    var iconName: String {
        switch self {
        case .like:
            return "heart"
        case .comment:
            return "message"
        }
    }


}

struct PostButtonView: View {
    var type: PostButtonType
    var count: Int
    var body: some View {
        HStack {
            Image(systemName: type.iconName)
            Text("\(count)").font(.system(size: 13))

        }
    }
}
