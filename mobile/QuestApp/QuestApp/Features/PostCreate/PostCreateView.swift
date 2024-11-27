//
//  PostCreateView.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 27.11.2024.
//

import SwiftUI

struct PostCreateView: View {
    @State private var content = ""
    var body: some View {

        NavigationStack {
            VStack {
                Spacer().frame(height: 40)
                TextField("Write something...", text: $content,axis: .vertical).frame(maxHeight: 250,alignment: .top)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)



            }.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top).navigationTitle("Create Post").navigationBarTitleDisplayMode(.inline).navigationBarItems(trailing: Button(action: /*@START_MENU_TOKEN@*/ { }/*@END_MENU_TOKEN@*/, label: {
                    Text("Share Post").font(.system(size: 14)).foregroundColor(.blue)
                }))
        }
    }
}

#Preview {
    PostCreateView()
}
