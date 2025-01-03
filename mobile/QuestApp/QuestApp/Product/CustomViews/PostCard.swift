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
    var post: PostListModel
    
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "-" }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = formatter.date(from: dateString) else { return "-" }
        
        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.locale = Locale(identifier: "tr_TR")
        relativeFormatter.unitsStyle = .full
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Profil resmi ve kullanıcı bilgileri
            HStack(alignment: .center) {
                Image("login")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(post.userName ?? "Unknown")
                        .font(.headline)
                        .fontWeight(.medium)
                    Text(formatDate(post.createdAt))
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                .padding(.leading, 10)
            }
            .padding(.leading, 10)
            .padding(.bottom, 10)
            
            // Post içeriği
            Text(post.content)
                .padding(.leading, 10)
                .padding(.bottom, 10)
            
            // Post resmi
            if let imageUrl = post.imageUrl, !imageUrl.isEmpty {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 200)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
            
            // Düğmeler
            HStack {
                PostButtonView(type: .like, count: post.likes?.count ?? 0)
                PostButtonView(type: .comment, count: post.commentCount ?? 0)
            }
            .padding(.leading, 10)
        }
        .frame(width: 400, alignment: .leading)
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
