//
//  LoginView.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 25.11.2024.
//

import SwiftUI

struct LoginView: View {
    @State private var isLoggedIn = false 
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("login")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 200)
                    .clipShape(.buttonBorder)
                
                Text("Log In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                TextField("Username", text: .constant(""))
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: .constant(""))
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                
                Button(action: {
                    // Giriş işlemi başarılıysa isLoggedIn'i true yap
                    isLoggedIn = true
                }, label: {
                    Text("Log In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                .navigationDestination(isPresented: $isLoggedIn) {
                    FeedView().navigationBarBackButtonHidden(true)
                }
                .padding(.bottom, 20)
                
                NavigationLink(destination: RegisterView().navigationBarBackButtonHidden()) {
                    Text("Don't have an account?")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    LoginView()
}



