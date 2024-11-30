//
//  PostDetailView.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 26.11.2024.
//

import SwiftUI

struct PostDetailView: View {
    var post: PostModel

    var body: some View {
        VStack(
            alignment: .center,
            content: {
                PostCard(post: post)
                CommentListView()
                Spacer()
                CommentFieldView()
             }
        )
        .padding(.horizontal, 10)
        .frame(maxHeight: .infinity, alignment: .top) // Tüm alanı kullan ama yukarıya hizala
    }
}
/*
#Preview {
    PostDetailView(post: PostModel(id: 1, userId: 1, userName: "Osmancan", title: "Merhaba", content: "Selamlar", likes: [LikeModel(id: 1, userId: 1, postId: 1)]))
}*/

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct CommentFieldView: View {
    @State private var text: String = ""

    var body: some View {
        HStack(spacing:10, content: {
            
            Image("login")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            TextField("Yorum yaz",text: $text)
                .frame(width: 300, height: 50).background(.black.opacity(0.1)).cornerRadius(10)
        }).padding(.horizontal,15) .frame(width: 450,height: 80)
    }
}

struct CommentView: View {
    var body: some View {
        HStack(spacing:10, content: {
            
            Image("login")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            Text("Merhaba Osmancan nasılsın").font(.system(size: 14)).frame(maxWidth: 400,maxHeight: 60, alignment: .leading).padding(.all,5) .background(.black.opacity(0.1)).clipShape(
                RoundedCorner(radius: 10, corners: [.topLeft, .topRight, .bottomRight])
            )
            
        }).padding(.horizontal,50) .frame(maxWidth: .infinity,maxHeight: 80,alignment: .leading)
    }
}

struct CommentListView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())]) {
                ForEach(0..<10, id: \.self) { post in
                    CommentView()
                        .padding(.all,8) // Padding eklemek isteyebilirsiniz
                }
            }
            .padding(.zero)
        }.padding(.zero)
    }
}
