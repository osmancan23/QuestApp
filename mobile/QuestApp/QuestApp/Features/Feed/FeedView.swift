//
//  FeedView.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 25.11.2024.
//

import SwiftUI

struct FeedView: View {
    
    @ObservedObject var viewModel = FeedViewModel()
    @State var isLoading: Bool = false

    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10)]) {
                    ForEach(viewModel.posts) { post in
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
        }.onAppear(perform:  {
            viewModel.fetchPosts()
        })
    }
}

#Preview {
    FeedView()
}

