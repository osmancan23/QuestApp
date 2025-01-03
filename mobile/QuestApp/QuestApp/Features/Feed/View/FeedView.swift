//
//  FeedView.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 25.11.2024.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    @ObservedObject var authManager: AuthManager
    @EnvironmentObject var router: Router

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    Text("Yükleniyor...")
                     .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.posts.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.posts) { post in
                                PostCard(post: post).onTapGesture {
                                    router.navigate(to: .postDetail(postId: post.id))
                                }
                                    
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.fetchPosts()
                    }
                }
            }
            .navigationTitle("Ana Sayfa")
            
            .onAppear {
                viewModel.fetchPosts()
            }
            .alert("Hata", isPresented: .init(get: { viewModel.errorMessage != nil },
                                            set: { _ in viewModel.errorMessage = nil })) {
                Button("Tamam", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "doc.text.image.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.blue)
                    .symbolEffect(.pulse)
                
                Text("Henüz Gönderi Yok")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("İlk gönderiyi sen paylaş ve\narkadaşlarınla etkileşime geç!")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
               
                
                Button(action: {
                    Task {
                        await viewModel.fetchPosts()
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Yenile")
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
        .background(
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
        )
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(authManager: AuthManager())
            .environmentObject(Router())
    }
}
