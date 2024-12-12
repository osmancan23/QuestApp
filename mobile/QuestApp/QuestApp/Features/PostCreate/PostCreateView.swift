//
//  PostCreateView.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 27.11.2024.
//

import SwiftUI
import Alamofire

struct PostCreateView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel = PostCreateViewModel()

    var body: some View {

        VStack {
            Spacer().frame(height: 40)
            TextField("Write something...", text: $viewModel.content, axis: .vertical).frame(maxHeight: 250, alignment: .top)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 20)



        }.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top).navigationTitle("Create Post").navigationBarTitleDisplayMode(.inline).navigationBarItems(trailing: Button(action: {
            viewModel.sharePost()
        }, label: {
                Text("Share Post").font(.system(size: 14)).foregroundColor(.blue)
            }).alert("Post Created", isPresented: $viewModel.isPostCreated, actions: {
                Button("OK", role: .cancel) { }

            }))

    }
}
