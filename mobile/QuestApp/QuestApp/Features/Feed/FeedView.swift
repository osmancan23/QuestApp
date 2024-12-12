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
    @EnvironmentObject var router: Router


    var body: some View {


        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10)]) {
                ForEach(viewModel.posts.reversed()) { post in
                    PostCard(post: post).onTapGesture {
                        router.navigate(to: .postDetail(post: post))
                    }

                }

            }.navigationTitle("Posts").navigationBarItems(trailing: Button("Create Post", action: {
                isLoading = true
                router.navigate(to: .postCreate)
            }))
        }.onAppear(perform: {
            viewModel.fetchPosts()
        }).navigationBarBackButtonHidden(true)

    }
}

#Preview {
    FeedView()
}

