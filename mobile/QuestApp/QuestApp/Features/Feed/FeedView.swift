//
//  FeedView.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 25.11.2024.
//

import SwiftUI

struct FeedView: View {
    @State var isLoading = false
    @State var postList: [PostModel] = [
        //create examples data
        PostModel(id: 1, userId: 1, userName: "Osmancan", title: "First Post", content: "Hello World", likes: [LikeModel(id: 1, userId: 1, postId: 1)]),
        PostModel(id: 2, userId: 2, userName: "John", title: "Second Post", content: "Hello World", likes: [LikeModel(id: 1, userId: 1, postId: 1)]),
        PostModel(id: 3, userId: 3, userName: "Doe", title: "Third Post", content: "Hello World", likes: [LikeModel(id: 1, userId: 1, postId: 1)]),
        PostModel(id: 4, userId: 4, userName: "Jane", title: "Fourth Post", content: "Hello World", likes: [LikeModel(id: 1, userId: 1, postId: 1)]),
    ]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10)]) {
                    ForEach(postList) { post in
                        NavigationLink(destination: PostDetailView(post: post)) {
                                PostCard(post: post)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    
                }.navigationTitle("Posts").onAppear(perform: {
    
                }).navigationBarItems(trailing: Button("Create Post", action: {
                    isLoading = true
                }).navigationDestination(isPresented: $isLoading, destination: {
                    PostCreateView()
                }))
            }
        }
    }
}

#Preview {
    FeedView()
}

